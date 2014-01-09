class Equipment < ActiveRecord::Base
  belongs_to :parent, :foreign_key => "parent_id", :class_name => "EquipmentCategory"
  has_and_belongs_to_many :eventdates

  validates_presence_of  :description, :position, :parent_id,:shortname
  validates_associated   :parent
  attr_accessible :description, :shortname, :position, :parent_id
end
