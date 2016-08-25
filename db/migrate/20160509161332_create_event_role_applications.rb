class CreateEventRoleApplications < ActiveRecord::Migration
  def change
    create_table :event_role_applications do |t|
      t.references :event_role, null: false
      t.references :member, null: false
      
      t.timestamps null: false
    end
  end
end
