class CreateBlackouts < ActiveRecord::Migration
  def up
    create_table :blackouts do |t|
      t.string :title
      t.references :event, index: true
      t.datetime :startdate, null: false
      t.datetime :enddate, null: false

      t.timestamps
    end
    
    Event.where(blackout: true).flat_map(&:eventdates).each do |ed|
      b = Blackout.new
      b.title = ed.description
      b.event = ed.event
      b.startdate = ed.startdate.beginning_of_day
      b.enddate = ed.enddate.end_of_day
      b.save
    end
    
    remove_column :events, :blackout
  end
  
  def down
    add_column :events, :blackout, :boolean, :default => false, :null => false
    
    Blackout.all.each do |b|
      b.event.update_column(:blackout, true)
    end
    
    drop_table :blackouts
  end
end
