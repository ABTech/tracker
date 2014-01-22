class AddDeviseToMembers < ActiveRecord::Migration
  def self.up
    rename_column :members, :crypted_password, :encrypted_password
    change_column :members, :encrypted_password, :string, :limit => 128, :default => "", :null => false
    rename_column :members, :salt, :password_salt
    change_column :members, :password_salt, :string, :default => "", :null => false
    
    change_table(:members) do |t|
      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, :default => 0, :null => false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip
    end
  end

  def self.down
    remove_column :members, :remember_created_at
    remove_column :members, :sign_in_count
    remove_column :members, :current_sign_in_at
    remove_column :members, :last_sign_in_at
    remove_column :members, :current_sign_in_ip
    remove_column :members, :last_sign_in_ip
    
    rename_column :members, :encrypted_password, :crypted_password
    change_column :members, :crypted_password, :string, :limit => 40
    rename_column :members, :password_salt, :salt 
    change_column :members, :salt, :string, :limit => 40
  end
end
