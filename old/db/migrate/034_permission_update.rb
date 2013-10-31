class PermissionUpdate < ActiveRecord::Migration
  def self.up
    remove_column("permissions", "info");
  end

  def self.down
  end
end
