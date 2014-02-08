class TimecardEntry < ActiveRecord::Base
  belongs_to :member
  belongs_to :eventdate
  belongs_to :timecard

  validates_presence_of :member_id, :eventdate_id, :hours
  validates_numericality_of :hours, :less_than_or_equal_to => 37.5, :greater_than => 0
  validates_associated :member
  validates_inclusion_of :timecard, :in => Timecard.valid_timecards, :message => 'is not a current timecard', :allow_nil => true
  validate :eventdate_in_range, :check_submitted
  before_destroy :check_submitted

  private
    def eventdate_in_range
      errors.add(:eventdate, 'is invalid') unless timecard.nil? or timecard.valid_eventdates.include? eventdate
    end

    def check_submitted
      return false if !timecard.nil? and timecard.submitted
    end

  public
    def gross_amount
      #TODO: I think it's a bug that payrate is not mandatory.
      (payrate and hours*payrate) or hours*member.payrate
    end
end
