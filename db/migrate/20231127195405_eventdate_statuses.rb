class EventdateStatuses < ActiveRecord::Migration[6.1]
  def up
    add_column :eventdates, :status, :string, default: "Date Incomplete"
  end

  def down
    remove_column :eventdates, :status
  end
end
