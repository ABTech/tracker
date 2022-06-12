class Kiosk < ApplicationRecord
  devise :database_authenticatable, :lockable, :trackable,
  lock_strategy: :failed_attempts,
  maximum_attempts: 1, unlock_strategy: :none,
  send_email_changed_notification: false, send_password_change_notification: false,
  authentication_keys: [:hostname]  # instead of email

  def ability
    @ability ||= KioskAbility.new(self)
  end
end
