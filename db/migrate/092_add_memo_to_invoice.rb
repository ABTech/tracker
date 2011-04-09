class AddMemoToInvoice < ActiveRecord::Migration
	def self.up
		add_column :invoices, :memo, :text
	end

	def self.down
		remove_column :invoices, :memo
	end
end
