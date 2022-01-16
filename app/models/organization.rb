class Organization < ApplicationRecord
  has_many :events
  
  after_save :set_eventdate_delta_flags

  validates_presence_of :name
  validate :organization_do_not_modify_default
  
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

    def organization_do_not_modify_default
      if (self.changed? or self.new_record?) and self.id == 0
        errors.add(:base, "Change of default organization is not allowed!")
      end
    end
end
