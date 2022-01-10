class Organization < ApplicationRecord
  has_many :events
  
  after_save :set_eventdate_delta_flags

  validates_presence_of :name
  
  scope :active, -> { where(defunct: false) }

  ThinkingSphinx::Callbacks.append(self, :behaviours => [:sql, :deltas])  # associated via eventdate
  
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
