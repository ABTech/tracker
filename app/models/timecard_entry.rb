class TimecardEntry < ActiveRecord::Base
	def self.valid_events
		return Event.find(:all, :order => 'updated_on ASC')
	end
	belongs_to :member
	belongs_to :event
	validates_presence_of :member_id, :event_id, :hours
	validates_numericality_of :hours, :member_id
	validates_inclusion_of :event_id, :in => self.valid_events.map {|e| e.id }, :message => 'is invalid'

	attr_protected :member_id


end
