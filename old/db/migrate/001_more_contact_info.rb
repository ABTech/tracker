class MoreContactInfo < ActiveRecord::Migration
  def self.up
    add_column("events", "contactemail", :text);
    rename_column("events", "contactinfo", "contactdetail");
  end

  def self.down
  end
end
