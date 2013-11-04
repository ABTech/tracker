class CreateEventRoles < ActiveRecord::Migration
  def change
    create_table :event_roles do |t|
      t.references :event, index: true
      t.references :member, index: true
      t.string :role

      t.timestamps
    end
  end
end
