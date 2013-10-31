class UserFilterAssociation < ActiveRecord::Migration
  def self.up
    add_column("member_filters", "member_id", :integer, :null => false);
  end

  def self.down
  end
end
