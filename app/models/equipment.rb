class Equipment < ActiveRecord::Base
  belongs_to :parent, :foreign_key => "parent_id", :class_name => "EquipmentCategory"
  has_and_belongs_to_many :eventdates
  has_many :equipment_events
  has_many :events, :through => :equipment_events

  validates_presence_of  :description, :position, :parent_id, :shortname
  validates_associated   :parent
  
  scope :active, -> { where(defunct: false) }
end
