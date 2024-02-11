class AddEventdateFkToTimecards < ActiveRecord::Migration[6.1]
  def up
    change_column :timecard_entries, :eventdate_id, :bigint
    add_foreign_key :timecard_entries, :eventdates
  end
  def down
    remove_foreign_key :timecard_entries, :eventdates
    change_column :timecard_entries, :eventdate_id, :integer
  end
end
