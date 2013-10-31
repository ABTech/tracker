# == Schema Information
#
# Table name: equipment
#
#  id          :integer          not null, primary key
#  parent_id   :integer          not null
#  description :string(255)      not null
#  position    :integer          not null
#  shortname   :string(255)      not null
#

class Equipment < ActiveRecord::Base
    belongs_to :parent, :foreign_key => "parent_id", :class_name => "EquipmentCategory";
    has_and_belongs_to_many :eventdates;

    validates_presence_of  :description, :position, :parent_id,:shortname;
    validates_associated   :parent;
end
