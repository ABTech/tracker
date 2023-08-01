class AddLastRepresentativeDateToEvents < ActiveRecord::Migration[6.1]
  def up
    add_column :events, :last_representative_date, :datetime
    add_index :events, :last_representative_date
    Event.where("last_representative_date IS ?", nil).find_each do |event|
      event.save
    end
  end
  def down
    remove_index :events, name: "index_events_on_last_representative_date"
    remove_column :events, :last_representative_date
  end
end
