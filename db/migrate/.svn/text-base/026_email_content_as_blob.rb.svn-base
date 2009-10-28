class EmailContentAsBlob < ActiveRecord::Migration
  def self.up
    change_column("emails", "contents", :text, :null => false);
  end

  def self.down
  end
end
