class CreateEquipment < ActiveRecord::Migration
  def change
    create_table :equipment do |t|
      t.integer :parent_id
      t.string :description
      t.integer :position
      t.string :shortname

      t.timestamps
    end
  end
end
