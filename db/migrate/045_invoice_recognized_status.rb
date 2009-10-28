class InvoiceRecognizedStatus < ActiveRecord::Migration
  def self.up
    add_column("invoices", "recognized", :boolean, :null => false);
  end

  def self.down
  end
end
