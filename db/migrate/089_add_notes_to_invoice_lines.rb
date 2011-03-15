class AddNotesToInvoiceLines < ActiveRecord::Migration
	def self.up
		add_column("invoice_lines","notes",:text)
	end

	def self.down
		
	end
end
