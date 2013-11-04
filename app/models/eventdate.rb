class Eventdate < ActiveRecord::Base
  belongs_to :event
  has_many :timecard_entries
  has_and_belongs_to_many :locations;
  has_and_belongs_to_many :equipment;

  validates_presence_of :startdate, :enddate, :description, :event, :locations;
  validates_associated :locations, :equipment;
  validate :dates

  Event_Span_Days       = 2;
  Event_Span_Seconds    = Event_Span_Days * 24 * 60 * 60;

  def dates
    errors.add_to_base("We're not a time machine. (End Date can't be before Start Date)") unless startdate<enddate
  end
  
  def valid_call?
    return (calldate &&
            (calldate.to_i < startdate.to_i) &&
            ((startdate.to_i - calldate.to_i) < Event_Span_Seconds));
  end

  def valid_strike?
    return (strikedate &&
            (strikedate.to_i >= enddate.to_i) &&
            ((strikedate.to_i - enddate.to_i) < Event_Span_Seconds));
  end
end
