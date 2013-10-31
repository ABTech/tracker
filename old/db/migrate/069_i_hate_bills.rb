class IHateBills < ActiveRecord::Migration
  def self.up
	remove_column("invoice_lines", "bill_id")
	drop_table "bills"
  end
  
  def self.down
    
  end
end