class EmailForm < ActiveRecord::Base
  validates_presence_of :description, :contents
  
  #attr_accessible :description, :contents
end
