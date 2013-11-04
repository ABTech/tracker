class CreateEventdateLocations < ActiveRecord::Migration
  def change
    create_table :eventdate_locations do |t|
      t.references :eventdate, index: true
      t.references :location, index: true

      t.timestamps
    end
  end
end
