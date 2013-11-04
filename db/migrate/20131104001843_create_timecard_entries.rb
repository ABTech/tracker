class CreateTimecardEntries < ActiveRecord::Migration
  def change
    create_table :timecard_entries do |t|
      t.references :member, index: true
      t.float :hours
      t.references :eventdate, index: true
      t.references :timecard, index: true
      t.float :payrate

      t.timestamps
    end
  end
end
