class AddDefunctFlagToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :defunct, :boolean, :default => false, :null => false
  end
end
