class Email < ApplicationRecord
  belongs_to :event
  has_many :attachments, as: :attachable
  
  scope :received, -> { where(sent: false).order(timestamp: :desc) }
  scope :sent, -> { where(sent: true).order(timestamp: :desc) }
  scope :unread, -> { where(unread: true).order(timestamp: :desc) }
    
  validates_presence_of :sender, :timestamp, :contents
  validates_format_of :sender, :with => Event::EmailRegex, :multiline => true
  
  attr_accessor :recipient, :cc, :bcc

  def quoteless_contents
    contents.lines.reject { |l| l[0] == ">" or (l.start_with? "On" and l.end_with? " wrote:\n") }.join("")
  end
  
  def one_quote_contents
    contents.lines.reject { |l| l[0] == ">" and l[1] == ">" or (l.start_with? "> On" and l.end_with? " wrote:\n") }.join("")
  end
  
  def display_title
    timestamp.strftime("%A, %B %d at %I:%M %p") + " - " + subject
  end
  
  def to_s
    subject
  end
  
  def reply(member)
    m = Email.new
    m.in_reply_to = message_id
    m.recipient = sender
    m.subject = subject.downcase.start_with?("re: ") ? subject : ("Re: " + subject)
    m.sender = member.email
    m.cc = "abtech@andrew.cmu.edu"
    m.contents = reply_text
    m
  end
  
  def reply_text
    "\n\nOn #{timestamp.strftime("%a, %b %-d, %Y at %-l:%M %p")}, #{sender} wrote:\n\n" + contents.lines.collect do |line|
      if line.start_with? ">"
        ">" + line
      else
        "> " + line
      end
    end.join("")
  end
  
  def make_tree
    if in_reply_to
      replied = Email.where(message_id: in_reply_to).first
      if replied
        replied.make_tree
      else
        { :email => self, :children => make_tree_children }
      end
    else
      { :email => self, :children => make_tree_children }
    end
  end
  
  def make_tree_children
    Email.where(in_reply_to: message_id).map do |child|
      { :email => child, :children => child.make_tree_children }
    end
  end
  
  def self.create_from_mail(mail)
    return false if Email.where(message_id: mail.message_id).exists?

    message = Email.new
    message.sender = mail.reply_to ? mail.reply_to[0] : mail.from[0]
    message.timestamp = mail.date
    message.subject = mail.subject
    message.message_id = mail.message_id
    message.headers = mail.header.to_s
    message.unread = true
    message.in_reply_to = mail.in_reply_to
    
    attachments = mail.attachments
    
    if not mail.multipart?
      if mail.text?
        msg_content = mail.body.decoded
        msg_charset = mail.charset
      else
        msg_content = "[Attachment]"
        msg_charset = nil
        attachments = [mail]
      end
    elsif mail.text_part
      msg_content = mail.text_part.body.decoded
      msg_charset = mail.text_part.charset
    elsif mail.html_part
      msg_content = Sanitize.clean(mail.html_part.body.decoded)
      msg_charset = mail.html_part.charset
    else
      return false
    end
    
    if msg_charset
      message.contents = msg_content.force_encoding(msg_charset).encode('UTF-8')
    else
      message.contents = msg_content
    end
    
    # threading
    if mail.subject
      subject_stripped = mail.subject
      
      while subject_stripped.downcase.start_with? "re: "
        subject_stripped = subject_stripped[4..-1]
      end

      subjects = [mail.subject, "Re: " + mail.subject, subject_stripped, "Re: " + subject_stripped].collect(&:downcase).uniq
      if mail.in_reply_to
        prev = Email.where("message_id = ? OR (sender = ? AND LCASE(subject) IN (?))", mail.in_reply_to, mail.from[0], subjects).first
      else
        prev = Email.where("(sender = ?) AND (LCASE(subject) IN (?)) AND (timestamp > ?)", mail.from[0], subjects, message.timestamp - 180.days).first
      end
    
      if prev
        message.event_id = prev.event_id
      elsif mail.subject.start_with? "[AB Tech] Request | "
        repdate = Date.strptime(mail.subject[mail.subject.size - 10, 10], "%m/%d/%Y")
        event = Event.where("title = ? AND representative_date >= ? AND representative_date <= ?", mail.subject[20, mail.subject.size - 31], repdate - 1.day, repdate + 2.day).first

        if event
          message.event_id = event.id
        end
      end
    else
      # no subject!
      message.subject = "<no subject>"
    end
    
    if message.save
      Dir.mktmpdir do |dir|
        attachments.each do |a|
          File.open(dir + "/" + a.filename, "w:ASCII-8BIT") do |f|
            f.write(a.body.decoded)
            f.flush
            f.rewind
          
            message.attachments.create!(attachment: f)
          end
        end
      end
      
      return true
    end
    
    return false
  end
end
