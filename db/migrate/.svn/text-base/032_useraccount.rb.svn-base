class Useraccount < ActiveRecord::Migration
  def self.up
      add_column("members", :login,                     :string);
      add_column("members", :email,                     :string);
      add_column("members", :crypted_password,          :string, :limit => 40);
      add_column("members", :salt,                      :string, :limit => 40);
      add_column("members", :created_at,                :datetime);
      add_column("members", :updated_at,                :datetime);
      add_column("members", :remember_token,            :string);
      add_column("members", :remember_token_expires_at, :datetime);
  end

  def self.down
  end
end
