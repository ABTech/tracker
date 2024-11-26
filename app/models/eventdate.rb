class Eventdate < ApplicationRecord
  belongs_to :event, optional: true
  has_many :event_roles, :as => :roleable, :dependent => :destroy
  has_many :timecard_entries
  has_and_belongs_to_many :locations
  has_and_belongs_to_many :equipment_profile

  amoeba do
    include_association [:event_roles, :locations, :equipment_profile]
  end

  accepts_nested_attributes_for :event_roles, :allow_destroy => true

  validates_presence_of :startdate, :enddate, :description, :locations, :calltype, :striketype
  validates_associated :locations, :equipment_profile
  validate :dates, :validate_call, :validate_strike

  before_validation :prune_roles
  after_save :synchronize_representative_dates

  before_destroy :check_can_destroy

  Event_Span_Days       = 2;
  Event_Span_Seconds    = Event_Span_Days * 24 * 60 * 60;

  extend Enumerize
  enumerize :calltype, in: ["literal", "blank_call", "startdate"], default: "blank_call"
  enumerize :striketype, in: ["literal", "enddate", "none", "blank_strike"], default: "enddate"

  scope :call_between, ->(starttime, endtime) do
    where(calldate: starttime..endtime, calltype: "literal")
    .or(where(startdate: starttime..endtime, calltype: "startdate"))
  end

  scope :strike_between, ->(starttime, endtime) do
    where(strikedate: starttime..endtime, striketype: "literal")
    .or(where(enddate: starttime..endtime, striketype: "enddate"))
  end

  ThinkingSphinx::Callbacks.append(self, :behaviours => [:sql, :deltas])

  def dates
    if startdate and enddate
      errors.add(:base, "We're not a time machine. (End Date can't be before Start Date)") unless startdate < enddate
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

  def can_destroy?
    not self.timecard_entries.any?
  end

  def check_can_destroy
    if not self.can_destroy?
      errors.add(:base, "Cannot delete an eventdate that has been billed for")
      throw(:abort)
    end
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

  def synchronize_representative_dates
    self.event.synchronize_representative_dates
  end

  def full_roles
    if self.event_roles.empty?
      self.event.event_roles
    else
      roles = self.event_roles

      if not roles.any? { |r| r.role == EventRole::Role_HoT }
        roles += self.event.event_roles.find_all { |r| r.role == EventRole::Role_HoT }
      end

      if not roles.any? { |r| r.role == EventRole::Role_sTiC }
        roles += self.event.event_roles.find_all { |r| r.role == EventRole::Role_sTiC }
      end

      if not roles.any? { |r| r.role == EventRole::Role_TiC }
        roles += self.event.event_roles.find_all { |r| r.role == EventRole::Role_TiC }
      end

      roles
    end
  end

  def tic
    t = event_roles.where(role: [EventRole::Role_sTiC, EventRole::Role_TiC, EventRole::Role_aTiC]).where.not(member: nil).all.map(&:member)
    return t unless t.empty?
    return event.tic if event
    []
  end

  def tic_only
    t = event_roles.where(role: [EventRole::Role_TiC]).where.not(member: nil).all.map(&:member)
    return t unless t.empty?
    return event.tic_only if event
    []
  end

  def stic_only
    t = event_roles.where(role: [EventRole::Role_sTiC]).where.not(member: nil).all.map(&:member)
    return t unless t.empty?
    return event.stic_only if event
    []
  end

  def tic_and_stic_only
    t = event_roles.where(role: [EventRole::Role_sTiC, EventRole::Role_TiC]).where.not(member: nil).all.map(&:member)
    return t unless t.empty?
    return event.tic_and_stic_only if event
    []
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
      if ed.startdate < DateTime.now.beginning_of_week
        0
      else
        DateTime.now.beginning_of_week.upto(ed.startdate.to_datetime).count.fdiv(7).floor  # https://stackoverflow.com/a/35092981
      end
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
