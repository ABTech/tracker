class StaffPhoneString < ActiveRecord::Migration
  def self.up
      change_column("members", "phone", :string);
  end

  def self.down
  end
end
