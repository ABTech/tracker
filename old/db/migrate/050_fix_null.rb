class FixNull < ActiveRecord::Migration
  def self.up
    remove_column("members", "remember_token_expires_at");
    add_column("members", "remember_token_expires_at", :datetime);  
  end

  def self.down
  end
end
