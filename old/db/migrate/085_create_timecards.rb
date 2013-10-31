class CreateTimecards < ActiveRecord::Migration
  def self.up
    create_table :timecards do |t|
      t.column :member_id, :integer
      t.column :billing_date, :datetime
      t.column :due_date, :datetime
      t.column :submitted, :boolean
    end
		add_column :timecard_entries, :timecard_id, :integer
		remove_column :timecard_entries, :billed
  end

  def self.down
    drop_table :timecards
		remove_column :timecard_entries, :timecard_id
		add_column :timecard_entries, :billed, :datetime
  end
end
