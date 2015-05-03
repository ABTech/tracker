class Blackout < ActiveRecord::Base
  belongs_to :event
  
  attr_accessor :with_new_event, :blackout_include
  
  validates :startdate, :enddate, presence: true
  validate :chronologicality, :informative
  
  private
    def chronologicality
      errors[:enddate] << "can't be before Start Date." if startdate > enddate
    end
    
    def informative
      errors[:base] << "Blackout must have at least a title or an associated event." if self.title.blank? and self.event.blank? and not self.with_new_event
    end
end
