class StupidError < ActiveRecord::Migration
  def self.up
    rename_column("events", "quote", "price_quote");
    add_column("events", "location_id", :integer);
  end

  def self.down
  end
end
