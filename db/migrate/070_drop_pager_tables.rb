class DropPagerTables < ActiveRecord::Migration
  def self.up
    drop_table("pagers");
    drop_table("pages");
  end

  def self.down
  end
end
