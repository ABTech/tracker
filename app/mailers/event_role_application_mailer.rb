class EventRoleApplicationMailer < ActionMailer::Base

  def apply(application, notes)
    @application = application
    @notes = notes

    mail to: application.superior_email, from: "no-reply@tracker.abtech.org", subject: "Application for #{application.event_role.description} #{application.event_role.role}"
  end
end
