class CreateEventRequests < ActiveRecord::Migration
  def change
    create_table :event_requests do |t|
      t.string :contact_name
      t.string :contact_email
      t.string :contact_phone
      t.string :org
      t.datetime :event_start
      t.datetime :event_end
      t.string :location
      t.datetime :reservation_start
      t.datetime :reservation_end
      t.text :memo
      t.string :oracle_string

      t.timestamps
    end
  end
end
