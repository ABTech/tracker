class Location < ApplicationRecord
  has_and_belongs_to_many :eventdates
  
  around_update :set_eventdate_delta_flags

  validates_presence_of :building, :room
  validate :location_do_not_modify_default
  
  scope :active, -> { where(defunct: false) }
  scope :buildings, -> { active.order(building: :asc).select(:building).distinct.pluck(:building) }
  scope :building, -> (building) { active.where(building: building).order(room: :asc) }
  scope :sorted, -> { order(id: :asc) }

  ThinkingSphinx::Callbacks.append(self, :behaviours => [:sql, :deltas])  # associated via eventdate

  def to_s
    "#{building} - #{room}"
  end
  
  private
    def set_eventdate_delta_flags
      was_changed = self.changed?

      yield

      if was_changed
        eventdates.each do |eventdate|
          eventdate.delta = true
          eventdate.save
        end
      end
    end

    def location_do_not_modify_default
      if self.id == 0
        errors.add(:base, "Change of default location is not allowed!")
      end
    end
end
