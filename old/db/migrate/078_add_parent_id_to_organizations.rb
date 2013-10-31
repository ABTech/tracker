class AddParentIdToOrganizations < ActiveRecord::Migration
  #this migration allows organziations to acts_as_tree
  def self.up
    add_column :organizations, "parent_id", :integer
    Organization.find(:all).each do |o|
      o.parent_id = -1
      o.save
    end
  end

  def self.down
    remove_column :organizations, "parent_id", :integer
  end
end
