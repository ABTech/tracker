class RemoveDeadTables < ActiveRecord::Migration
  def up
    drop_table :member_filters
    drop_table :pages
    drop_table :pagers
    drop_table :bugs
  end
  
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
