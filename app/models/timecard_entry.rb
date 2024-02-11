class TimecardEntry < ApplicationRecord
  belongs_to :member
  belongs_to :eventdate, required: true
  belongs_to :timecard

  extend Enumerize
  enumerize :eventpart, in: ["call", "show", "strike"], default: "show"

  validates_presence_of :eventdate, :member_id, :hours, :eventpart
  validates_numericality_of :hours, :less_than_or_equal_to => 37.5, :greater_than => 0
  validates_associated :member
  validates_inclusion_of :timecard, :in => ->(t){Timecard.valid_timecards}, :message => 'is not a current timecard', :allow_nil => true
  validate :eventdate_in_range, :check_submitted
  before_destroy :check_submitted

  private
    def eventdate_in_range
      errors.add(:eventdate, 'is not in this timecard\'s time range') unless timecard.nil? or timecard.valid_eventdates.include? eventdate
    end

    def check_submitted
      return false if !timecard.nil? and timecard.submitted
    end

  public
    def gross_amount
      #TODO: I think it's a bug that payrate is not mandatory.
      (payrate and hours*payrate) or hours*member.payrate
    end

    def eventdate_id_and_eventpart
      "#{eventdate_id}-#{eventpart}"
    end

    def eventdate_id_and_eventpart=(eventdate_id_and_eventpart)
      self[:eventdate_id], self[:eventpart] = eventdate_id_and_eventpart.split("-")
    end
end
