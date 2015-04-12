class AddDeltaIndexToEventdate < ActiveRecord::Migration
  def change
    add_column :eventdates, :delta, :boolean, :default => true, :null => false
  end
end
