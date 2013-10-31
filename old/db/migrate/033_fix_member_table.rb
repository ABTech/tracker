class FixMemberTable < ActiveRecord::Migration
  def self.up
    remove_column("members", "login");
    remove_column("members", "email");
  end

  def self.down
  end
end
