class ConvertEquipmentEventdatesToEquipmentEvents < ActiveRecord::Migration
  def up
    EquipmentEventdate.all.each do |eq_ed|
      eq_ev = EquipmentEvent.new
      eq_ev.equipment_id = eq_ed.equipment_id
      eq_ev.event_id = eq_ed.eventdate.event_id
      eq_ev.quantity = 1
      eq_ev.eventdate_start_id = eq_ed.eventdate_id
      eq_ev.eventdate_end_id = eq_ed.eventdate_id
      eq_ev.save
    end
  end

  def down
    EquipmentEvent.all.each do |eq_ev|
      eq_ev.destroy
    end
  end
end
