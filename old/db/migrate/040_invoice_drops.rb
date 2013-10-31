class InvoiceDrops < ActiveRecord::Migration
  def self.up
    remove_column("invoices", "date");
    remove_column("invoices", "organization_id");
    remove_column("invoices", "name");
  end

  def self.down
  end
end
