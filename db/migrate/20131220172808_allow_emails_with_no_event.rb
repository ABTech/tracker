class AllowEmailsWithNoEvent < ActiveRecord::Migration
  def change
    change_column :emails, :event_id, :integer, :null => true
  end
end
