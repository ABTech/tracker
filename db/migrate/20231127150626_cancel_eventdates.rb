class CancelEventdates < ActiveRecord::Migration[6.1]
  def up
    add_column :eventdates, :cancelled, :boolean, default: false
  end

  def down
    remove_column :eventdates, :cancelled
  end
end
