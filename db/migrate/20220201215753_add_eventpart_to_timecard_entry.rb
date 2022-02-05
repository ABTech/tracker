class AddEventpartToTimecardEntry < ActiveRecord::Migration[6.1]
  def change
    add_column :timecard_entries, :eventpart, :string
  end
end
