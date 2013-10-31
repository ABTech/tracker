class InvoiceColumns < ActiveRecord::Migration
  def self.up
    remove_column("invoices", "je_inv_id");
    remove_column("invoices", "je_inv_paid_id");
    remove_column("invoices", "paymentinfo");
    add_column("invoices", "payment_type", :string);
    add_column("invoices", "oracle_string", :string);
  end

  def self.down
  end
end
