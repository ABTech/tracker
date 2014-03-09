class MergeEventdateRolesIntoEventRoles < ActiveRecord::Migration
  def up
    roles = ActiveRecord::Base.connection.select_all("SELECT * FROM eventdate_roles").to_a
    drop_table :eventdate_roles
    
    rename_column :event_roles, :event_id, :roleable_id
    add_column :event_roles, :roleable_type, :string, :null => false
    EventRole.all.each do |er|
      er.update_column(:roleable_type, "Event")
    end
    
    roles.each do |edr|
      er = EventRole.new
      er.roleable_id = edr[:eventdate_id]
      er.roleable_type = "Eventdate"
      er.role = edr[:role]
      er.save
    end
  end
  
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
