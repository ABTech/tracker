class AdminMailer < ActionMailer::Base
  def cleanup_backups
    mail to: "abtech@andrew.cmu.edu"
  end
end
