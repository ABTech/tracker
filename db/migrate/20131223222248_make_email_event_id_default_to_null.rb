class MakeEmailEventIdDefaultToNull < ActiveRecord::Migration
  def change
    change_column :emails, :event_id, :integer, :null => true, :default => nil
  end
end
