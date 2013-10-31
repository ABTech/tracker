class EventUpdateColumn < ActiveRecord::Migration
  def self.up
    add_column("events", "updated_on", :datetime);
  end

  def self.down
  end
end
