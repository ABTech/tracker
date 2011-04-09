class AddPayrateToTimecardAndMember < ActiveRecord::Migration
	def self.up
		add_column :members, :payrate, :float
		add_column :timecard_entries, :payrate, :float
	end

	def self.down
		remove_column :members, :payrate
		remove_column :timecard_entries, :payrate
	end
end
