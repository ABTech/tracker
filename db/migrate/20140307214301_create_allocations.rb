class CreateAllocations < ActiveRecord::Migration
  def change
    create_table :allocations do |t|
      t.string :category, null: false
      t.string :object_code, null: false
      t.string :line_item, null: false
      t.decimal :budget, null: false
      t.integer :year, null: false
      t.text :notes

      t.timestamps
    end
  end
end
