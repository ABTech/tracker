class EventRoles < ActiveRecord::Migration
  def self.up
    remove_column("events", "tic_id");
    create_table("events_roles") {};
    add_column("events_roles", "event_id", :integer);
    add_column("events_roles", "member_id", :integer);
    add_column("events_roles", "role", :string);
  end

  def self.down
  end
end
