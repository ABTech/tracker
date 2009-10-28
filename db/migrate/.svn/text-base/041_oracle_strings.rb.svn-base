class OracleStrings < ActiveRecord::Migration
  def self.up
    add_column("invoices", "paymentinfo", :string);
    rename_column("invoice_lines", "number", "quantity");
  end

  def self.down
  end
end
