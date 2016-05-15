class EventRoleApplicationMailer < ActionMailer::Base

  def apply(application, notes)
    superior = application.event_role.superior
    if superior.nil?
      email = "abtech@andrew.cmu.edu"
    else
      ser = application.event_role.roleable.event_roles.where(role: superior)
      if ser.empty?
        ser = application.event_role.roleable.tic
        if ser.empty?
          email = "abtech@andrew.cmu.edu"
        else
          email = ser.member.email
        end
      else
        email = ser.first.member.email
      end
    end
    
    @application = application
    @notes = notes

    mail to: email, from: "no-reply@tracker.abtech.org", subject: "Application for #{application.event_role.description} #{application.event_role.role}"
  end
end
