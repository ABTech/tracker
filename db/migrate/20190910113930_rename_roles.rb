class RenameRoles < ActiveRecord::Migration[5.0]
  def up
    EventRole.where(role: 'supervise').update_all(role: 'attend')
    EventRole.where(role: 'exec').update_all(role: 'supervise')
  end

  def down
    EventRole.where(role: 'supervise').update_all(role: 'exec')
    EventRole.where(role: 'attend').update_all(role: 'supervise')
  end
end
