class TiCasmember < ActiveRecord::Migration
  def self.up
    remove_column("events", "tic");
    add_column("events", "tic_id", :integer);
  end

  def self.down
  end
end
