class TimecardEntry < ActiveRecord::Base
	def self.valid_eventdates
		return Eventdate.find(:all, :order => 'startdate ASC')
	end
	belongs_to :member
	belongs_to :eventdate
	validates_presence_of :member_id, :eventdate_id, :hours
	validates_numericality_of :hours, :member_id
	validates_inclusion_of :eventdate_id, :in => self.valid_eventdates.map {|e| e.id }, :message => 'is invalid'

	attr_protected :member_id


end
