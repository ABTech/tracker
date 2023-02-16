class RenameRoleSuperviseTosTiC < ActiveRecord::Migration[6.1]
  def up
    EventRole.where(role: 'supervise').update_all(role: 'sTiC')
  end

  def down
    EventRole.where(role: 'sTiC').update_all(role: 'supervise')
  end
end
