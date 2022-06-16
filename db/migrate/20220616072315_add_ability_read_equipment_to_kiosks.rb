class AddAbilityReadEquipmentToKiosks < ActiveRecord::Migration[6.1]
  def change
    add_column :kiosks, :ability_read_equipment, :boolean, null: false, default: false
  end
end
