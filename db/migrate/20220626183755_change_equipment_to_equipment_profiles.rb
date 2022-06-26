class ChangeEquipmentToEquipmentProfiles < ActiveRecord::Migration[6.1]
  def change
    rename_table :equipment, :equipment_profiles
    rename_table :equipment_eventdates, :equipment_profiles_eventdates
    rename_column :equipment_profiles_eventdates, :equipment_id, :equipment_profile_id
    rename_table :equipment_events, :equipment_profiles_events
    rename_column :equipment_profiles_events, :equipment_id, :equipment_profile_id
  end
end
