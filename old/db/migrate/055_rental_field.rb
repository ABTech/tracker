class RentalField < ActiveRecord::Migration
  def self.up
    add_column("events", "rental", :boolean, :null => false);
  end

  def self.down
  end
end
