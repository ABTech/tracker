class Email < ActiveRecord::Base
  belongs_to :event
  has_many :attachments, as: :attachable
  
  scope :received, -> { where(sent: false).order(timestamp: :desc) }
  scope :sent, -> { where(sent: true).order(timestamp: :desc) }
  scope :unread, -> { where(unread: true).order(timestamp: :desc) }
    
  validates_presence_of :sender, :timestamp, :contents
  validates_format_of :sender, :with => Event::EmailRegex, :multiline => true

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
  
  def self.create_from_mail(mail)
    return false if Email.where(message_id: mail.message_id).exists?
    
    message = Email.new
    message.sender = mail.reply_to ? mail.reply_to.address : mail.from[0]
    message.timestamp = mail.date
    message.subject = mail.subject
    message.message_id = mail.message_id
    message.headers = mail.header.to_s
    message.unread = true
    
    if not mail.multipart?
      message.contents = mail.body.decoded
    elsif mail.text_part
      message.contents = mail.text_part.body.decoded
    elsif mail.html_part
      message.contents = Sanitize.clean(message.html_part.body.decoded)
    else
      return false
    end
    
    message.contents = message.contents.force_encoding('iso8859-1').encode("utf-8")
    
    # threading
    subject_stripped = mail.subject
    while subject_stripped.start_with? "Re: "
      subject_stripped = subject_stripped[4..-1]
    end
    
    subjects = [mail.subject, "Re: " + mail.subject, subject_stripped, "Re: " + subject_stripped].collect(&:downcase).uniq
    if mail.in_reply_to
      prev = Email.where("message_id = ? OR (sender = ? AND LCASE(subject) IN (?))", mail.in_reply_to, mail.from[0], subjects).first
    else
      prev = Email.where("sender = ? AND LCASE(subject) IN (?)", mail.from[0], subjects).first
    end
    
    if prev
      message.event_id = prev.event_id
    end
    
    message.save!
    
    Dir.mktmpdir do |dir|
      mail.attachments.each do |a|
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
end
