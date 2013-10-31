class LocationTags3 < ActiveRecord::Migration
  def self.up
    rename_table("event_tags", "event_locations");
  end

  def self.down
  end
end
