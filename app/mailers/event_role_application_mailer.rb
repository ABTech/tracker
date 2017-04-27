class EventRoleApplicationMailer < ActionMailer::Base

  def apply(application, notes)
    @application = application
    @notes = notes

    mail to: application.superior_email, from: "no-reply@abtech.andrew.cmu.edu", subject: "Application for #{application.event_role.description} #{application.event_role.role}"
  end
  
  def accept(application)
    @application = application
    
    mail to: application.member.email, from: "no-reply@abtech.andrew.cmu.edu", subject: "Application for #{application.event_role.description} #{application.event_role.role} Accepted"
  end
end
