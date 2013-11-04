class CreateEquipmentCategories < ActiveRecord::Migration
  def change
    create_table :equipment_categories do |t|
      t.string :name
      t.integer :parent_id
      t.integer :position

      t.timestamps
    end
  end
end
