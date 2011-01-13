class AddDatesToTimecard < ActiveRecord::Migration
  def self.up
		add_column :timecards, :start_date, :datetime
		add_column :timecards, :end_date, :datetime
  end

  def self.down
		remove_column :timecards, :start_date
		remove_column :timecards, :end_date
  end
end
