class NewEquipmentFlow < ActiveRecord::Migration
  def up
    categories = {}
    ActiveRecord::Base.connection.select_all("SELECT * FROM equipment_categories WHERE parent_id != 0").to_a.each do |ec|
      categories[ec["id"]] = {
        :name => ec["name"],
        :parent => ec["parent_id"]
      }
    end
    
    drop_table :equipment_categories
    add_column :equipment, :category, :string, null: false
    add_column :equipment, :subcategory, :string
    
    Equipment.order(position: :asc).each do |equip|
      if categories[equip.parent_id][:parent] != 1
        equip.category = categories[categories[equip.parent_id][:parent]][:name]
        equip.subcategory = categories[equip.parent_id][:name]
      else
        equip.category = categories[equip.parent_id][:name]
      end
      
      equip.save!
    end
    
    remove_column :equipment, :parent_id
    remove_column :equipment, :position
  end
  
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
