class MakeInvoicePriceDecimal < ActiveRecord::Migration
	def self.up
		change_column :invoice_lines, :price, :float
	end

	def self.down
		change_column :invoice_lines, :price, :integer
	end
end
