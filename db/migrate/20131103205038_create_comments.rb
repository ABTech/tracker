class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :member, index: true
      t.text :content
      t.references :event, index: true

      t.timestamps
    end
  end
end
