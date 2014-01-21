class AddDefunctFlagToEquipment < ActiveRecord::Migration
  def change
    add_column :equipment, :defunct, :boolean, :default => false, :null => false
  end
end
