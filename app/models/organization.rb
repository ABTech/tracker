class Organization < ApplicationRecord
  has_many :events
  
  validates_presence_of :name
  validate :organization_do_not_modify_default
  
  scope :active, -> { where(defunct: false) }

  private
    def organization_do_not_modify_default
      if (self.changed? or self.new_record?) and self.id == 0
        errors.add(:base, "Change of default organization is not allowed!")
      end
    end
end
