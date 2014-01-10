class EventdateLocation < ActiveRecord::Base
  belongs_to :eventdate
  belongs_to :location
end
