class AddAbilityIndexWeatherToKiosks < ActiveRecord::Migration[6.1]
  def change
    add_column :kiosks, :ability_index_weather, :boolean, null: false, default: false
  end
end
