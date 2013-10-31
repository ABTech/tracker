# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  member_id  :integer
#  content    :text
#  event_id   :integer
#  created_at :datetime
#  updated_at :datetime
#

class Comment < ActiveRecord::Base
  belongs_to :event
  belongs_to :member
before_destroy :can_destroy?

attr_accessor :current_member

def can_destroy?
  current_member==member
end

end
