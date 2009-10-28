class CreateBill < ActiveRecord::Migration
  def self.up
    create_table :bills do |t|
      t.column "created_at", :datetime;
      t.column "date", :datetime, :null => false;
      t.column "organization_id", :integer, :null => false;
      t.column "name", :string, :null => false;
      t.column "state", :string, :null => false;
      t.column "category", :string, :null => false;
      t.column "je_bill_id", :integer, :null => false;
      t.column "je_bill_paid_id", :integer, :null => false;
      t.column "invoice_id", :integer, :null => false;
    end
    add_index("bills", "organization_id");
    add_index("bills", "date");
    add_index("bills", "category");

    create_table :bill_lines do |t|
      t.column "bill_id", :integer, :null => false;
      t.column "memo", :string, :null => false;
      t.column "price", :integer, :null => false;
      t.column "number", :integer, :null => false;
    end
    add_index("bill_lines", "bill_id");

  end

  def self.down
    drop_table :bills;
    drop_table :bill_lines;
  end
end
