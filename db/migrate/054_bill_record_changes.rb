class BillRecordChanges < ActiveRecord::Migration
  def self.up
    remove_column("bills", "name");
    rename_column("bills", "state", "status");
  end

  def self.down
  end
end
