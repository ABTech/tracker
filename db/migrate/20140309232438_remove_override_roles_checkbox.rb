class RemoveOverrideRolesCheckbox < ActiveRecord::Migration
  def change
    remove_column :eventdates, :override_roles, :boolean
  end
end
