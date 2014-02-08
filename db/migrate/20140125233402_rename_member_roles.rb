class RenameMemberRoles < ActiveRecord::Migration
  def up
    Member.where(role: "membership_management").update_all(:role => "tracker_management")
    Member.where(role: "treasurer").update_all(:role => "tracker_management")
    Member.where(role: "tracker_dev").update_all(:role => "admin")
  end
  
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
