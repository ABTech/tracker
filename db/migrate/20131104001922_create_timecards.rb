class CreateTimecards < ActiveRecord::Migration
  def change
    create_table :timecards do |t|
      t.datetime :billing_date
      t.string :rails
      t.string :g
      t.string :model
      t.datetime :due_date
      t.boolean :submitted
      t.datetime :start_date
      t.datetime :end_date

      t.timestamps
    end
  end
end
