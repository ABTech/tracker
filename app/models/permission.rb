class Permission < ActiveRecord::Base
  has_and_belongs_to_many :roles
  
  attr_accessible :pattern

  def to_s
    pattern
  end
end
