class ChangeConnectionStringName < ActiveRecord::Migration
  def self.up
    rename_column("pagers", "connection", "connectionstr");
  end

  def self.down
  end
end
