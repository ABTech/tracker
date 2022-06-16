class AddShowHeaderTimeToKiosks < ActiveRecord::Migration[6.1]
  def change
    add_column :kiosks, :show_header_time, :boolean, null: false, default: true
  end
end
