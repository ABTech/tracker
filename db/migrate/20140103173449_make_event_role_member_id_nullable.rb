class MakeEventRoleMemberIdNullable < ActiveRecord::Migration
  def change
    change_column :event_roles, :member_id, :integer, :null => true
  end
end
