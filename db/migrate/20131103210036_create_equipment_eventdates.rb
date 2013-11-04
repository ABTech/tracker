class CreateEquipmentEventdates < ActiveRecord::Migration
  def change
    create_table :equipment_eventdates do |t|
      t.references :eventdate, index: true
      t.references :equipment, index: true

      t.timestamps
    end
  end
end
