# == Schema Information
# Schema version: 80
#
# Table name: equipment_categories
#
#  id        :integer(11)     not null, primary key
#  name      :string(255)     not null
#  parent_id :integer(11)     not null
#  position  :integer(11)     not null
#

class EquipmentCategory < ActiveRecord::Base
    acts_as_tree :order => "position";
    has_many :equipment, :foreign_key => :parent_id;
    belongs_to :parent, :foreign_key => "parent_id", :class_name => "EquipmentCategory"

    Root_Category = 1;

    validates_presence_of :name, :position;
    validates_associated :parent;

    def self.tree_as_collection(id=Root_Category)
        node = EquipmentCategory.find(id);
        list = [];

        children = node.children | node.equipment;
        children = children.sort_by {|i| i.position};

        children.each do |child|
            if(child.class == Equipment)
                list << child;
            else
                list = list.concat(tree_as_collection(child.id));
            end
        end

        return list;
    end
end
