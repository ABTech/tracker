class AddShowHeaderNetworkStatusToKiosks < ActiveRecord::Migration[6.1]
  def change
    add_column :kiosks, :show_header_network_status, :boolean, null: false, default: true
  end
end
