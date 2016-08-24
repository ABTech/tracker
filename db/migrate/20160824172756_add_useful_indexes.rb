class AddUsefulIndexes < ActiveRecord::Migration[5.0]
  def change
    add_index :attachments, [:attachable_id, :attachable_type]
    add_index :comments, :event_id
    add_index :equipment_eventdates, :eventdate_id
    add_index :equipment_eventdates, :equipment_id
    add_index :event_role_applications, :event_role_id
    add_index :event_role_applications, :member_id
    remove_index :event_roles, :roleable_id
    add_index :event_roles, [:roleable_id, :roleable_type]
    add_index :events, :organization_id
    add_index :events, :representative_date
    add_index :timecard_entries, :member_id
    add_index :timecard_entries, :eventdate_id
    add_index :timecard_entries, :timecard_id
  end
end
