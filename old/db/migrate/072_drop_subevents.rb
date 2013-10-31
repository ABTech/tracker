class DropSubevents < ActiveRecord::Migration
  def self.up
    drop_table("subevents");
    drop_table("subevent_times");
  end

  def self.down
  end
end
