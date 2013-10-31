class BillNotes < ActiveRecord::Migration
  def self.up
    add_column("bills", "notes", :text);
    remove_column("bills", "quantity");
  end

  def self.down
  end
end
