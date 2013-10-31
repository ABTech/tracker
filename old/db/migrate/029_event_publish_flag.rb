class EventPublishFlag < ActiveRecord::Migration
  def self.up
    add_column("events", "publish", :boolean, :default => false);
  end

  def self.down
  end
end
