class RemoveUnusedMemberFields < ActiveRecord::Migration[5.0]
  def change
    remove_column :members, :payroll_paperwork_date
    remove_column :members, :ssi_date
    remove_column :members, :driving_paperwork_date
    remove_column :members, :key_possession
  end
end
