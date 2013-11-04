class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :building
      t.string :floor
      t.string :room
      t.text :details

      t.timestamps
    end
  end
end
