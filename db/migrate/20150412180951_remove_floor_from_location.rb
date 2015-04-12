class RemoveFloorFromLocation < ActiveRecord::Migration
  def change
    remove_column :locations, :floor, :string, :null => false
  end
end
