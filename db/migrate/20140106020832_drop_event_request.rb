class DropEventRequest < ActiveRecord::Migration
  def up
    drop_table :event_requests
  end
  
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
