class TimecardEntry < ActiveRecord::Base
  belongs_to :member
  belongs_to :eventdate
  belongs_to :timecard
end
