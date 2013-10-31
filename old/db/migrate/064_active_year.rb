class ActiveYear < ActiveRecord::Migration
  def self.up
    add_column("years", "active", :integer, :default => 0, :null => false);
  end

  def self.down
  end
end
