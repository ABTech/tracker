class CreatePagers < ActiveRecord::Migration
  def change
    create_table :pagers do |t|
      t.string :pagertype
      t.string :connectionstr
      t.references :member, index: true
      t.integer :priority

      t.timestamps
    end
  end
end
