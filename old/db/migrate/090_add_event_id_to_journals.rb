class AddEventIdToJournals < ActiveRecord::Migration
	def self.up
		add_column :journals, :event_id, :integer
		rename_column :journals, :link_id, :invoice_id
	end

	def self.down
		rename_colunn :journals, :invoice_id, :link_id
		remove_columnn :journals, :event_id
	end
end
