class Comment < ActiveRecord::Base
  belongs_to :member
  belongs_to :event
  
  validates :content, presence: true

  attr_accessor :current_member
  attr_accessible :content

  before_destroy :can_destroy?

  def can_destroy?
    current_member==member
  end
end
