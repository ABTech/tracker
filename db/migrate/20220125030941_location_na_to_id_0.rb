class LocationNaToId0 < ActiveRecord::Migration[6.1]
  def change
    if Location.exists?(id: 70, building: "N/A", room: "Not Available/Applicable")
      execute "UPDATE eventdates_locations SET location_id = 0 WHERE location_id = 70"
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
