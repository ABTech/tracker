class Eventdate < ApplicationRecord
  belongs_to :event
  has_many :event_roles, :as => :roleable, :dependent => :destroy
  has_many :timecard_entries
  has_and_belongs_to_many :locations
  has_and_belongs_to_many :equipment
  
  amoeba do
    include_association [:event_roles, :locations, :equipment]
  end

  accepts_nested_attributes_for :event_roles, :allow_destroy => true

  validates_presence_of :startdate, :enddate, :description, :locations, :calltype, :striketype
  validates_associated :locations, :equipment
  validate :dates, :validate_call, :validate_strike
  
  before_validation :prune_roles
  after_save :synchronize_representative_date

  Event_Span_Days       = 2;
  Event_Span_Seconds    = Event_Span_Days * 24 * 60 * 60;
  
  extend Enumerize
  enumerize :calltype, in: ["literal", "blank", "startdate"]
  enumerize :striketype, in: ["literal", "enddate", "none", "blank"]
  
  scope :call_between, ->(starttime, endtime) do
    where(calldate: starttime..endtime, calltype: "literal")
    .or(where(startdate: starttime..endtime, calltype: "startdate"))
  end
  
  scope :strike_between, ->(starttime, endtime) do
    where(strikedate: starttime..endtime, striketype: "literal")
    .or(where(enddate: starttime..endtime, striketype: "enddate"))
  end

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
  
  def full_roles
    if self.event_roles.empty?
      self.event.event_roles
    else
      roles = self.event_roles
      
      if not roles.any? { |r| r.role == EventRole::Role_HoT }
        roles += self.event.event_roles.find_all { |r| r.role == EventRole::Role_HoT }
      end
      
      if not roles.any? { |r| r.role == EventRole::Role_exec }
        roles += self.event.event_roles.find_all { |r| r.role == EventRole::Role_exec }
      end
      
      if not roles.any? { |r| r.role == EventRole::Role_TiC }
        roles += self.event.event_roles.find_all { |r| r.role == EventRole::Role_TiC }
      end
      
      roles
    end
  end
  
  def tic
    t = event_roles.where(role: [EventRole::Role_TiC, EventRole::Role_aTiC]).where.not(member: nil).all
    return t unless t.empty?
    return event.tic if event
    []
  end
  
  def exec
    t = event_roles.where(role: EventRole::Role_exec).first
    return t.member if t
    return event.exec if event
    nil
  end
  
  def has_run_position?(member)
    self.event_roles.where(member: member).count > 0
  end
  
  def run_positions_for(member)
    self.event_roles.where(member: member)
  end
  
  def self.runify(eventdates)
    eventdates.chunk do |ed|
      ed.full_roles
    end.map do |roles, run|
      run
    end
  end
  
  def self.weekify(eventdates)
    eventdates.chunk do |ed|
      TimeDifference.between(DateTime.now, ed.startdate).in_weeks.floor
    end.map do |weeks, eds|
      {
        :weeks_away => weeks,
        :eventruns => Eventdate.runify(eds)
      }
    end
  end
  
  private
    def prune_roles
      self.event_roles = self.event_roles.reject { |er| er.role.blank? }
    end
end
