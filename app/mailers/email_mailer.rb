class EmailMailer < ActionMailer::Base
  add_template_helper(EmailHelper)
  
  def weekly_events(sender, to, bcc, subject, intro_blurb, outro_blurb, eventdates)
    @intro_blurb = intro_blurb
    @outro_blurb = outro_blurb
    @eventdates = eventdates.chunk { |eventdate| eventdate.startdate.beginning_of_day }
    
    mail  :to => to,
          :from => sender.email,
          :bcc => bcc,
          :subject => subject
  end
  
end
