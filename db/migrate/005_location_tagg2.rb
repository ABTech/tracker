class LocationTagg2 < ActiveRecord::Migration
  def self.up
    rename_table("location_tags", "event_tags");
  end

  def self.down
  end
end
