class Timecard < ApplicationRecord
  has_many :timecard_entries
  has_many :members, -> { order("namelast ASC").distinct }, :through => :timecard_entries

  validates_presence_of :billing_date, :due_date, :start_date, :end_date
  validates_uniqueness_of :billing_date

  before_destroy :clear_entries

  after_save do |timecard|
    TimecardEntry.where("timecard_id IS NULL").each do |entry|
      entry.timecard = timecard
      entry.save
    end
  end

  def self.valid_eventdates
    timecards = self.valid_timecards
    return Eventdate.where(["startdate >= ? AND events.billable = ?", Account.magic_date, true]).includes(:event).references(:event).sort_by{|ed| ed.event.title} if timecards.size == 0
    start_date, end_date = timecards.inject([nil,nil]) do |pair, timecard|
      [
        ((pair[0].nil? or timecard.start_date < pair[0]) ? timecard.start_date : pair[0]), 
        ((pair[1].nil? or timecard.end_date > pair[1]) ? timecard.end_date : pair[1])
      ]
    end

    Eventdate.where("startdate >= ? AND startdate <= ? AND events.status IN (?) AND events.billable = ?", start_date, end_date, Event::Event_Status_Group_Not_Cancelled, true).order("startdate DESC").includes(:event).references(:event)
  end

  def self.valid_eventdates_and_parts
    dates = self.valid_eventdates
    dates_and_parts = []
    dates.each do |date|
      dates_and_parts.append({ eventdate: date, eventpart: "call"}) if date.billable_call?
      dates_and_parts.append({ eventdate: date, eventpart: "show"}) if date.billable_show?
      dates_and_parts.append({ eventdate: date, eventpart: "strike"}) if date.billable_strike?
    end
    dates_and_parts
  end

  def entries(member=nil)
    timecard_entries.where(member: member).order("eventdates.startdate ASC").includes(:eventdate).references(:eventdate) unless timecard_entries.nil?
  end

  def hours(member=nil)
    if member
      scope = timecard_entries.where(member: member)
    else
      scope = timecard_entries
    end
    
    if scope.empty?
      0
    else
      scope.map(&:hours).reduce(&:+).round(1)
    end
  end

  def self.latest_dates
    Timecard.order(billing_date: :desc).first
  end

  def self.valid_timecards
    Timecard.where(submitted: false).order("due_date DESC")
  end

  def clear_entries
    timecard_entries.each do |entry|
      entry.timecard = nil
      entry.save
    end
  end

  def valid_eventdates
    Eventdate.where("startdate >= ? AND startdate <= ? AND events.billable = ?", start_date, end_date, true).includes(:event).references(:event)
  end

  def valid_eventdates_and_parts
    dates = valid_eventdates
    dates_and_parts = []
    dates.each do |date|
      dates_and_parts.append({ eventdate: date, eventpart: "call"}) if date.billable_call
      dates_and_parts.append({ eventdate: date, eventpart: "show"}) if date.billable_show
      dates_and_parts.append({ eventdate: date, eventpart: "strike"}) if date.billable_strike
    end
    dates_and_parts
  end
end
