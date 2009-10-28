class LocationTags < ActiveRecord::Migration
  def self.up
    create_table(:location_tags) do |t| end
    add_column("location_tags", "location_id", :integer);
    add_column("location_tags", "event_id", :integer);
  end

  def self.down
  end
end
