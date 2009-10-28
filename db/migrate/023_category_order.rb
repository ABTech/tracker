class CategoryOrder < ActiveRecord::Migration
  def self.up
    add_column("equipment_categories", "position", :integer);
  end

  def self.down
  end
end
