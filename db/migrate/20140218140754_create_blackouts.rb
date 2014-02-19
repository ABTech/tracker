class CreateBlackouts < ActiveRecord::Migration
  def up
    create_table :blackouts do |t|
      t.string :title
      t.references :event, index: true
      t.date :startdate, null: false
      t.date :enddate, null: false

      t.timestamps
    end
    
    Event.where(blackout: true).flat_map(&:eventdates).each do |ed|
      b = Blackout.new
      b.title = ed.description
      b.event = ed.event
      b.startdate = ed.startdate
      b.enddate = ed.enddate
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
