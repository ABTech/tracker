class EquipmentProfile < ApplicationRecord
  has_and_belongs_to_many :eventdates

  validates_presence_of :description, :category, :shortname
  
  scope :active, -> { where(defunct: false) }
  scope :categories, -> { active.order(:category => :asc).select(:category).distinct.pluck(:category) }
  scope :subcategories, -> (category) { active.order(:subcategory => :asc).where(category: category).where.not(subcategory: nil).select(:subcategory).distinct.pluck(:subcategory) }
  scope :category, -> (category) { active.where(category: category, subcategory: nil) }
  scope :subcategory, -> (category, subcategory) { active.where(category: category, subcategory: subcategory) }
  
  before_validation :null_subcategory
  
  def full_category
    if self.subcategory
      "#{self.category} - #{self.subcategory}"
    else
      self.category
    end
  end
  
  private
    def null_subcategory
      self.subcategory = nil if self.subcategory.blank?
    end
end
