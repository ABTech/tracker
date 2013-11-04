class CreateBugs < ActiveRecord::Migration
  def change
    create_table :bugs do |t|
      t.references :member, index: true
      t.datetime :submitted_on
      t.text :description
      t.boolean :confirmed
      t.boolean :resolved
      t.datetime :resolved_on
      t.text :comment
      t.boolean :closed
      t.string :priority

      t.timestamps
    end
  end
end
