class UserPreferences < ActiveRecord::Migration
  def self.up
    add_column("members", "settingstring", :string);
  end

  def self.down
  end
end
