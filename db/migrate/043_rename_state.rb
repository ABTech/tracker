class RenameState < ActiveRecord::Migration
  def self.up
    rename_column("invoices", "state", "status");
  end

  def self.down
  end
end
