class Comment < ActiveRecord::Base
  belongs_to :member
  belongs_to :event

  attr_accessor :current_member

  before_destroy :can_destroy?

  def can_destroy?
    current_member==member
  end
end
