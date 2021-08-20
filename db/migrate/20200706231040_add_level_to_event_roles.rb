class AddLevelToEventRoles < ActiveRecord::Migration[5.0]
  def change
    add_column :event_roles, :level, :string
  end
end
