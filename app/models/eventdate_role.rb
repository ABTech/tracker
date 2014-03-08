class EventdateRole < ActiveRecord::Base
  belongs_to :eventdate
  belongs_to :member
end
