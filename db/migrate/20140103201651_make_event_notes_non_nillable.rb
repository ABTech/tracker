class MakeEventNotesNonNillable < ActiveRecord::Migration
  def up
    Event.where(notes: nil).each do |event|
      event.notes = ""
      event.save! :validate => false
    end
    
    change_column :events, :notes, :text, :null => false
  end
  
  def down
    change_column :events, :notes, :text, :null => true
  end
end
