# Preview all emails at http://localhost:3000/rails/mailers/event_role_application
class EventRoleApplicationPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/event_role_application/apply
  def apply
    EventRoleApplication.apply
  end

end
