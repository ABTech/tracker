class CreateTimecardEntries < ActiveRecord::Migration
  def self.up
    create_table :timecard_entries do |t|
      t.column :member_id, :integer
      t.column :event_id, :integer
      t.column :hours, :float
      t.column :billed, :datetime
    end
  end

  def self.down
    drop_table :timecard_entries
  end
end
