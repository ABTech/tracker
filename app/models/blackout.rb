class Blackout < ActiveRecord::Base
  belongs_to :event
  
  validates :startdate, :enddate, presence: true
  validate :chronologicality, :informative
  
  private
    def chronologicality
      errors[:enddate] << "can't be before Start Date." if startdate > enddate
    end
    
    def informative
      errors[:base] << "Blackout must have at least a title or an associated event." if self.title.blank? and self.event.blank?
    end
end
