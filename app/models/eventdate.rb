class Eventdate < ActiveRecord::Base
  belongs_to :event
  has_many :timecard_entries
  has_and_belongs_to_many :locations
  has_and_belongs_to_many :equipment

  validates_presence_of :startdate, :enddate, :description, :locations, :calltype, :striketype
  validates_associated :locations, :equipment
  validate :dates, :validate_call, :validate_strike
  
  after_save :synchronize_representative_date

  Event_Span_Days       = 2;
  Event_Span_Seconds    = Event_Span_Days * 24 * 60 * 60;
  
  include Enumerize
  enumerize :calltype, in: ["literal", "blank", "startdate"]
  enumerize :striketype, in: ["literal", "enddate", "none", "blank"]

  def dates
    if startdate and enddate
      errors[:base] << "We're not a time machine. (End Date can't be before Start Date)" unless startdate < enddate
    end
  end
  
  def validate_call
    errors.add(:calldate, "must be within two days strictly prior to the event starting") unless valid_call?
  end
  
  def validate_strike
    errors.add(:strikedate, "must be within two days after the event ending") unless valid_strike?
  end
  
  def valid_call?
    (calltype != "literal") || (
          (calldate.to_i <= startdate.to_i) &&
          ((startdate.to_i - calldate.to_i) < Event_Span_Seconds))
  end

  def valid_strike?
    (striketype != "literal") || (
          (strikedate.to_i >= enddate.to_i) &&
          ((strikedate.to_i - enddate.to_i) < Event_Span_Seconds))
  end
  
  def has_call?
    self.calltype == "literal" or self.calltype == "startdate"
  end
  
  def has_strike?
    self.striketype == "literal" or self.striketype == "enddate"
  end
  
  def effective_call
    return nil unless self.has_call?
    return self.startdate if self.calltype == "startdate"
    self.calldate
  end
  
  def effective_strike
    return nil unless self.has_strike?
    return self.enddate if self.striketype == "enddate"
    self.strikedate
  end
  
  def times
    times = []
    
    if self.has_call?
      times << { :date => self.effective_call, :name => "Call", :same => false }
      times << { :date => self.startdate, :name => "Event Starts", :same => (self.startdate.day == self.effective_call.day)}
    else
      times << { :date => self.startdate, :name => "Event Starts", :same => false }
    end
    
    times << { :date => self.enddate, :name => "Event Ends", :same => (self.enddate.day == self.startdate.day)}
    
    if self.has_strike?
      times << { :date => self.effective_strike, :name => "Strike", :same => (self.effective_strike.day == self.enddate.day)}
    end
    
    times
  end
  
  def total_hours
    timecard_entries.map(&:hours).reduce(0, &:+)
  end
  
  def total_gross
    timecard_entries.map(&:gross_amount).reduce(0.0, &:+)
  end
  
  def synchronize_representative_date
    self.event.synchronize_representative_date
  end
end
