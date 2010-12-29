class ChangeTimecardEntryForeignKey < ActiveRecord::Migration
  def self.up
		add_column :timecard_entries, :eventdate_id, :integer
		remove_column :timecard_entries, :event_id
  end

  def self.down
		add_column :timecard_entries, :event_id, :integer
		remove_column :timecard_entries, :eventdate_id
  end
end
