class AddOverrideRolesToEventdates < ActiveRecord::Migration
  def change
    add_column :eventdates, :override_roles, :boolean
  end
end
