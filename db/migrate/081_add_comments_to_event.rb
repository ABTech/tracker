class AddCommentsToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :comments, :text
  end

  def self.down
    remove_column :events, :comments
  end
end
