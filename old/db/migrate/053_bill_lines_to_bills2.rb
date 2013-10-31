class BillLinesToBills2 < ActiveRecord::Migration
  def self.up
    change_column("bills", "memo", :string, :null=>false);
    change_column("bills", "price", :string, :null=>false);
    change_column("bills", "quantity", :string, :null=>false);
  end

  def self.down
  end
end
