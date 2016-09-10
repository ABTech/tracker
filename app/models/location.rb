class Location < ApplicationRecord
  has_and_belongs_to_many :eventdates
  
  around_update :set_eventdate_delta_flags

  validates_presence_of :building, :room
  
  scope :active, -> { where(defunct: false) }
  scope :buildings, -> { active.order(building: :asc).select(:building).distinct.pluck(:building) }
  scope :building, -> (building) { active.where(building: building).order(room: :asc) }
  scope :sorted, -> { order(id: :asc) }

  def to_s
    return (building + " - " + room);
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
end
