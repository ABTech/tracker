class SetDefaultMemberRole < ActiveRecord::Migration
  def up
    change_column :members, :role, :string, :null => false, :default => "general_member"
  end
  
  def down
    change_column :members, :role, :string, :null => false, :default => nil
  end
end
