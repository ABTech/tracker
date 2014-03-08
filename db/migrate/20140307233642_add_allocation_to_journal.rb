class AddAllocationToJournal < ActiveRecord::Migration
  def change
    add_column :journals, :allocation_id, :integer, index: true
  end
end
