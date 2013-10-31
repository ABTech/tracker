class CreateInvoice < ActiveRecord::Migration
  def self.up
    create_table :invoices do |t|
      t.column "created_at", :datetime;
      t.column "date", :datetime, :null => false;
      t.column "organization_id", :integer, :null => false;
      t.column "name", :string, :null => false;
      t.column "event_id", :integer, :null => false;
      t.column "state", :string, :null => false;
      t.column "je_inv_id", :integer, :null => false;
      t.column "je_inv_paid_id", :integer, :null => false;
    end
    add_index("invoices", "date");
    add_index("invoices", "organization_id");
    add_index("invoices", "event_id");
    
    create_table :invoice_items do |t|
      t.column "memo", :string, :null => false;
      t.column "category", :string, :null => false;
      t.column "price_recognized", :integer, :null => false;
      t.column "price_unrecognized", :integer, :null => false;
    end
    add_index("invoice_items", "category");
    
    create_table :invoice_lines do |t|
      t.column "invoice_id", :integer, :null => false;
      t.column "memo", :string, :null => false;
      t.column "category", :string, :null => false;
      t.column "price", :integer, :null => false;
      t.column "number", :integer, :null => false;
      t.column "bill_id", :integer, :null => false;
    end
    add_index("invoice_lines", "invoice_id");
  end

  def self.down
    drop_table :invoices;
    drop_table :invoice_items;
    drop_table :invoice_lines;
  end
end
