class CreateEquipment < ActiveRecord::Migration
  def self.up
    create_table :equipment do |t|
    end

    add_column("equipment", "parent_id", :integer);
    add_column("equipment", "description", :string);
    add_column("equipment", "position", :integer);
  end

  def self.down
    drop_table :equipment
  end
end
