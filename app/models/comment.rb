class Comment < ActiveRecord::Base
  belongs_to :event
  belongs_to :member
before_destroy :can_destroy?

attr_accessor :current_member

def can_destroy?
  current_member==member
end

end
