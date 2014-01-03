class Eventdate < ActiveRecord::Base
  belongs_to :event
  has_many :timecard_entries
  has_and_belongs_to_many :locations
  has_and_belongs_to_many :equipment

  validates_presence_of :startdate, :enddate, :description, :locations
  validates_associated :locations, :equipment
  validate :dates, :validate_call, :validate_strike
  
  attr_accessor :call_literal, :strike_literal
  
  attr_accessible :event_id, :startdate, :description, :enddate, :calldate, :strikedate, :call_type, :strike_type, :location_ids, :equipment_ids, :call_literal, :strike_literal

  Event_Span_Days       = 2;
  Event_Span_Seconds    = Event_Span_Days * 24 * 60 * 60;

  def dates
    errors[:base] << "We're not a time machine. (End Date can't be before Start Date)" unless startdate<enddate
  end
  
  def validate_call
    errors.add(:calldate, "must be within two days strictly prior to the event starting") unless valid_call?
  end
  
  def validate_strike
    errors.add(:strikedate, "must be within two days after the event ending") unless valid_strike?
  end
  
  def valid_call?
    calldate.nil? || (
          (calldate.to_i < startdate.to_i) &&
          ((startdate.to_i - calldate.to_i) < Event_Span_Seconds))
  end

  def valid_strike?
    strikedate.nil? || (
          (strikedate.to_i >= enddate.to_i) &&
          ((strikedate.to_i - enddate.to_i) < Event_Span_Seconds))
  end
  
  def call_type=(type)
    if type == "blank"
      self.calldate = nil
    elsif type == "literal"
      self.calldate = self.call_literal
    end
  end
  
  def call_type
    return "blank" if self.calldate.nil?
    return "literal"
  end
  
  def strike_type=(type)
    if type == "blank"
      self.strikedate = nil
    elsif type == "enddate"
      self.strikedate = self.enddate
    elsif type == "literal"
      self.strikedate = self.strike_literal
    end
  end
  
  def strike_type
    return "blank" if self.strikedate.nil?
    return "enddate" if self.strikedate == self.enddate
    return "literal"
  end
end
