class EmailMailer < ActionMailer::Base
  add_template_helper(EmailsHelper)
  
  def weekly_events(sender, to, bcc, subject, body)
    mail  :to => to,
          :from => sender.email,
          :bcc => bcc,
          :subject => subject,
          :body => body
  end
  
  def reply(email)
    mail  :to => email.recipient,
          :from => email.sender,
          :cc => email.cc,
          :bcc => email.bcc,
          :subject => email.subject,
          :in_reply_to => email.in_reply_to do |format|
      format.text { render text: email.contents }
    end
  end
  
end
