class EventChanges < ActiveRecord::Migration
  def self.up
    remove_column("events", "contactdetail");
    add_column("events", "arb_description", :string);
  end

  def self.down
  end
end
