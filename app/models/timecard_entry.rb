class TimecardEntry < ActiveRecord::Base
	belongs_to :member
	belongs_to :event
	validates_presence_of :member_id, :event_id, :hours
	validates_numericality_of :hours, :event_id, :member_id

	attr_protected :member_id


	def self.valid_events
		return Event.find(:all, :order => 'updated_on ASC')
	end
end
