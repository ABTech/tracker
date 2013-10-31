class LocationTags4 < ActiveRecord::Migration
  def self.up
    rename_table("event_locations", "events_locations");
  end

  def self.down
  end
end
