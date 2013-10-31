class FilterDefaults < ActiveRecord::Migration
  def self.up
    change_column("member_filters", "name", :string, :null => false, :default => "new filter");
    change_column("member_filters", "displaylimit", :integer, :default => 0, :null => false);
  end

  def self.down
  end
end
