class AddEmailUnreadFlag < ActiveRecord::Migration
  def change
    add_column :emails, :unread, :boolean, null: false, default: false
    add_column :emails, :sent, :boolean, null: false, default: false
    
    remove_column :emails, :status, :string, null: false, default: "New"
  end
end
