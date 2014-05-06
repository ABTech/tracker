class AddTextableFlagToEvents < ActiveRecord::Migration
  def change
    add_column :events, :textable, :boolean, :default => false, :null => false
  end
end
