class Location < ApplicationRecord
  has_and_belongs_to_many :eventdates
  
  validates_presence_of :building, :room
  validate :location_do_not_modify_default
  
  scope :active, -> { where(defunct: false) }
  scope :buildings, -> { active.order(building: :asc).select(:building).distinct.pluck(:building) }
  scope :building, -> (building) { active.where(building: building).order(room: :asc) }
  scope :sorted, -> { order(id: :asc) }

  def to_s
    "#{building} - #{room}"
  end
  
  private
    def location_do_not_modify_default
      if (self.changed? or self.new_record?) and self.id == 0
        errors.add(:base, "Change of default location is not allowed!")
      end
    end
end
