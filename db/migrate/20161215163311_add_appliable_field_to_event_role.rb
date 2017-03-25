class AddAppliableFieldToEventRole < ActiveRecord::Migration[5.0]
  def change
    add_column :event_roles, :appliable, :boolean, null: false, default: true
  end
end
