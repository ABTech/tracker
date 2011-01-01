class TimecardEntry < ActiveRecord::Base
	belongs_to :timecard
	def self.valid_eventdates
		return Eventdate.find(:all, :order => 'startdate ASC')
	end
	belongs_to :member
	belongs_to :eventdate
	validates_presence_of :member_id, :eventdate_id, :hours
	validates_numericality_of :hours, :member_id
	validates_inclusion_of :eventdate_id, :in => self.valid_eventdates.map {|e| e.id }, :message => 'is invalid'
	validates_inclusion_of :timecard_id, :in => Timecard.valid_timecards.map {|t| t.id} << nil, :message => 'is invalid'
	before_validation :check_submitted
	before_destroy :check_submitted

	attr_protected :member_id

	private
	def check_submitted
		raise "Can't change entry after Timecard is submitted" if !timecard.nil? and timecard.submitted
	end
end
