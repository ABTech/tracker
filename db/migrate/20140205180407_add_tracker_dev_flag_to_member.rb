class AddTrackerDevFlagToMember < ActiveRecord::Migration
  def up
    add_column :members, :tracker_dev, :boolean, :null => false, :default => false
    
    egarbade = Member.find(102)
    egarbade.update_column(:role, "alumni")
    egarbade.update_column(:tracker_dev, true)
    
    krauchen = Member.find(159)
    krauchen.update_column(:role, "general_member")
    krauchen.update_column(:tracker_dev, true)
    
    merichar = Member.find(11)
    merichar.update_column(:role, "alumni")
    merichar.update_column(:tracker_dev, true)
    
    mreiss = Member.find(47)
    mreiss.update_column(:role, "alumni")
    mreiss.update_column(:tracker_dev, true)
    
    abtech = Member.find(5)
    abtech.update_column(:role, "general_member")
    abtech.update_column(:tracker_dev, true)
    
    treid = Member.find(83)
    treid.update_column(:role, "head_of_tech")
  end
  
  def down
    Member.where("tracker_dev = TRUE OR role = ?", "head_of_tech").each do |m|
      m.update_column(:role, "admin")
    end
    
    remove_column :members, :tracker_dev
  end
end
