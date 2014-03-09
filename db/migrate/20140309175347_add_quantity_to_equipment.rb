class AddQuantityToEquipment < ActiveRecord::Migration
  def change
    add_column :equipment, :quantity, :integer
  end
end
