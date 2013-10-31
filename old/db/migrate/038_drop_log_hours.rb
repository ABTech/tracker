class DropLogHours < ActiveRecord::Migration
  def self.up
    remove_column("event_logs", "time");
  end

  def self.down
  end
end
