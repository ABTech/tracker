class Organization < ActiveRecord::Base
  has_many :events

  validates_presence_of :name
  
  attr_accessible :name
  
  scope :active, -> { where(defunct: false) }
end
