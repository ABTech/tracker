class CreateEquipmentEvents < ActiveRecord::Migration
  def change
    create_table :equipment_events do |t|
      t.references :equipment, index: true
      t.references :event, index: true
      t.integer :quantity
      t.integer :eventdate_start_id, index:true
      t.integer :eventdate_end_id, index:true

      t.timestamps
    end
  end
end
