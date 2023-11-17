class EventRoleApplicationMailer < ActionMailer::Base

  def apply(application, notes)
    @application = application
    @notes = notes

    mail to: application.superior_emails, from: "no-reply@abtech.andrew.cmu.edu", subject: "Application for #{application.event_role.description} #{application.event_role.role} from #{application.member.display_name}"
  end
  
  def accept(application)
    @application = application
    
    mail to: application.member.email, from: "no-reply@abtech.andrew.cmu.edu", subject: "Application for #{application.event_role.description} #{application.event_role.role} Accepted"
  end

  def withdraw(application)
    @application = application

    mail to: application.superior_emails, from: "no-reply@abtech.andrew.cmu.edu", subject: "Application withdrawn for #{application.event_role.description} #{application.event_role.role} from #{application.member.display_name}"
  end
end
