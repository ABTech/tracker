class RemoveYears < ActiveRecord::Migration
  def change
    remove_column :events, :year_id
    drop_table :years
  end
end
