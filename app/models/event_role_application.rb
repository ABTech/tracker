class EventRoleApplication < ActiveRecord::Base
  belongs_to :event_role
  belongs_to :member
  
  validates_presence_of :event_role, :member
end
