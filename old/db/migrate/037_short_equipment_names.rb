class ShortEquipmentNames < ActiveRecord::Migration
  def self.up
    add_column("equipment", "shortname", :string);
    Equipment.find_all().each do |foo|
        foo.shortname = foo.description;
        foo.save();
    end
  end

  def self.down
    remove_column("equipment", "shortname");
  end
end
