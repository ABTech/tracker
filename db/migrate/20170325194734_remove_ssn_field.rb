class RemoveSsnField < ActiveRecord::Migration[5.0]
  def change
    remove_column :members, :ssn
  end
end
