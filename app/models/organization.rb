class Organization < ActiveRecord::Base
  has_many :events
  
  after_save :set_eventdate_delta_flags

  validates_presence_of :name
  
  scope :active, -> { where(defunct: false) }
  
  private
    def set_eventdate_delta_flags
      events.each do |event|
        event.eventdates.each do |eventdate|
          eventdate.delta = true
          eventdate.save
        end
      end
    end
end
