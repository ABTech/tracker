desc "Send a email reminder about cleaning up the database backups folder"
task :email_backup_reminder => :environment do
  AdminMailer.cleanup_backups.deliver_now
end