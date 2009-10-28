class EquipmentMappings < ActiveRecord::Migration
  def self.up
    create_table("equipment_eventdates", :id => false) do |t|;
        t.column("eventdate_id", :integer, :null => false);
        t.column("equipment_id", :integer, :null => false);
    end
  end

  def self.down
    drop_table("equipment_eventdates");
  end
end
