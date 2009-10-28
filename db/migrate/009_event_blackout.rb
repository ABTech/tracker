class EventBlackout < ActiveRecord::Migration
  def self.up
      add_column("events", "blackout", :boolean, {:null => false, :default => false});
  end

  def self.down
  end
end
