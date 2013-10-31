class DropEventLocations < ActiveRecord::Migration
  def self.up
    drop_table("events_locations");
    remove_column("events", "location_id");
  end

  def self.down
    raise IrreversibleMigration("can't undo");
  end
end
