class CreateEquipmentCategories < ActiveRecord::Migration
    def self.up
        create_table :equipment_categories do |t|
        end
        add_column("equipment_categories", "name", :string);
        add_column("equipment_categories", "parent_id", :integer);
    end

    def self.down
        drop_table :equipment_categories
    end
end
