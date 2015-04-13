class Location < ActiveRecord::Base
  has_and_belongs_to_many :eventdates
  
  after_save :set_eventdate_delta_flags

  validates_presence_of :building, :room
  
  scope :active, -> { where(defunct: false) }

  def to_s
    return (building + " - " + room);
  end
  
  private
    def set_eventdate_delta_flags
      eventdates.each do |eventdate|
        eventdate.delta = true
        eventdate.save
      end
    end
end
