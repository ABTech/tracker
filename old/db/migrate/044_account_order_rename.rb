class AccountOrderRename < ActiveRecord::Migration
  def self.up
    rename_column("accounts", "order", "position");
  end

  def self.down
  end
end
