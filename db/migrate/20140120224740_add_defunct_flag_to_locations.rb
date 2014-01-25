class AddDefunctFlagToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :defunct, :boolean, :default => false, :null => false
  end
end
