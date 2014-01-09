class AddRepresentativeDateToEvents < ActiveRecord::Migration
  def up
    add_column :events, :representative_date, :datetime
    
    Event.all.each do |event|
      event.representative_date = event.eventdates[0].startdate
      event.save! :validate => false
    end
    
    change_column :events, :representative_date, :datetime, :null => false
  end
  
  def down
    remove_column :events, :representative_date
  end
end
