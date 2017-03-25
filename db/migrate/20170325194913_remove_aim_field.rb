class RemoveAimField < ActiveRecord::Migration[5.0]
  def change
    remove_column :members, :aim
  end
end
