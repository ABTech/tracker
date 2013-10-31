class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.references :member
      t.text :content
      t.references :event

      t.timestamps
    end

    rename_column :events, :comments, :notes

  end

  def self.down
    rename_column :events, :notes, :comments
    drop_table :comments
  end
end
