class BillLinesToBills < ActiveRecord::Migration
  def self.up
    add_column("bills", "memo", :string);
    add_column("bills", "price", :integer);
    add_column("bills", "quantity", :integer);
    drop_table("bill_lines");
  end

  def self.down
  end
end
