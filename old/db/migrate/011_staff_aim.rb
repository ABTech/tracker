class StaffAim < ActiveRecord::Migration
  def self.up
      add_column("members", "aim", :string);
  end

  def self.down
  end
end
