class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      # t.column :name, :string
      t.column "building", :string
      t.column "floor", :string
      t.column "room", :string
      t.column "details", :text
    end
  end

  def self.down
    drop_table :locations
  end
end
