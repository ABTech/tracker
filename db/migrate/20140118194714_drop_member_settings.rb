class DropMemberSettings < ActiveRecord::Migration
  def up
    remove_column :members, :settingstring
  end
  
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
