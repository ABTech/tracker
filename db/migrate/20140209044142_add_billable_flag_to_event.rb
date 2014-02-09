class AddBillableFlagToEvent < ActiveRecord::Migration
  def up
    add_column :events, :billable, :boolean, :default => true, :null => false
    
    Event.where(blackout: true).each do |e|
      e.update_column(:billable, false)
    end
  end
  
  def down
    drop_column :events, :billable
  end
end
