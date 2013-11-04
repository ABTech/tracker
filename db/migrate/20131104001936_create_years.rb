class CreateYears < ActiveRecord::Migration
  def change
    create_table :years do |t|
      t.string :description
      t.integer :active

      t.timestamps
    end
  end
end
