class MakeTimecardSubmittedNotNillable < ActiveRecord::Migration
  def up
    Timecard.where(submitted: nil).each do |timecard|
      timecard.submitted = false
      timecard.save!
    end
    
    change_column :timecards, :submitted, :boolean, :null => false, :default => false
  end
  
  def down
    change_column :timecards, :submitted, :boolean
  end
end
