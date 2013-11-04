class CreateEventdates < ActiveRecord::Migration
  def change
    create_table :eventdates do |t|
      t.references :event, index: true
      t.datetime :startdate
      t.datetime :enddate
      t.datetime :calldate
      t.datetime :strikedate
      t.string :description

      t.timestamps
    end
  end
end
