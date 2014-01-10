class ChangeUnknownCallStrikeToNil < ActiveRecord::Migration
  def up
    change_column :eventdates, :calldate, :timestamp, :null => true
    change_column :eventdates, :strikedate, :timestamp, :null => true
    
    Eventdate.all.each do |ed|
      ed.calldate = nil unless ed.valid_call?
      ed.strikedate = nil unless ed.valid_strike?
      ed.save :validate => false
    end
  end
  
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
