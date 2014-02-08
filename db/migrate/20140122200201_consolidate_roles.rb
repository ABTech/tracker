class ConsolidateRoles < ActiveRecord::Migration
  def up
    add_column :members, :role, :string, :null => false
    
    Member.all.each do |m|
      roles = ActiveRecord::Base.connection.select_all("SELECT * FROM members_roles WHERE member_id = " + m.id.to_s).map {|h| h["role_id"] }
      
      if roles.include? 1
        m.update_column(:role, "tracker_dev")
      elsif roles.include? 6 or roles.include? 7
        m.update_column(:role, "membership_management")
      elsif roles.include? 4 or roles.include? 5 or roles.include? 8 or roles.include? 9
        m.update_column(:role, "exec")
      elsif roles.include? 2
        m.update_column(:role, "general_member")
      elsif roles.include? 10
        m.update_column(:role, "alumni")
      else
        m.update_column(:role, "suspended")
      end
    end
    
    drop_table :roles
    drop_table :permissions
    drop_table :permissions_roles
    drop_table :members_roles
  end
  
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
