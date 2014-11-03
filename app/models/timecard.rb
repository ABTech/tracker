class Timecard < ActiveRecord::Base
  has_many :timecard_entries
  has_many :members, -> { order("namelast ASC").distinct }, :through => :timecard_entries

  validates_presence_of :billing_date, :due_date, :start_date, :end_date
  validates_uniqueness_of :billing_date

  before_destroy :clear_entries

  after_save do |timecard|
    TimecardEntry.find(:all, :conditions => ["timecard_id is null"]).each do |entry|
      entry.timecard = timecard
      entry.save
    end
  end

  def self.valid_eventdates
    timecards = self.valid_timecards
    return Eventdate.where(["startdate >= ? AND events.billable = ?", Account::Magic_Date, true]).includes(:event).references(:event).sort_by{|ed| ed.event.title} if timecards.size == 0
    start_date, end_date = timecards.inject([nil,nil]) do |pair, timecard|
      [
        ((pair[0].nil? or timecard.start_date < pair[0]) ? timecard.start_date : pair[0]), 
        ((pair[1].nil? or timecard.end_date > pair[1]) ? timecard.end_date : pair[1])
      ]
    end

    Eventdate.where("startdate >= ? AND startdate <= ? AND events.status IN (?) AND events.billable = ?", start_date, end_date, Event::Event_Status_Group_Not_Cancelled, true).order("startdate DESC").includes(:event).references(:event)
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
    Timecard.find(:first, :order => 'billing_date DESC')
  end

  def self.valid_timecards
    Timecard.where(submitted: false).order("due_date DESC")
  end

  DAY = 24*60*60
  WEEK = 7*DAY

  # returns an array of size 14, where each element of the array corresponds
  # to one line on a printed timecard. The array element will be either
  # nil or an array of size 2. If it is an array, the two elements represent
  # the in and out times for that day, stored in a float as the number of
  # hours since the beginning of the day.
  def lines(member=nil)
    lines = Array.new(14)
    return if timecard_entries.nil?
    timecard_entries.each do |timecard_entry|
      next unless member.nil? or member == timecard_entry.member
      #calculate index of array corresponding to the day the eventdate is on
      idx = ((timecard_entry.eventdate.startdate - (billing_date - 2*WEEK))/(DAY).to_i - 1) % 14
      # try to put this timecard entry on the day of the event; if that
      # isn't possible, try the next day, and continue until we find a day
      # where we can put this timecard entry (or we've tried everything
      # and there's no room)
      unless try_add_entry(timecard_entry, idx, lines)
        new_idx = (idx + 1) % 14
        while (new_idx != idx and !try_add_entry(timecard_entry, new_idx, lines))
          new_idx = (new_idx + 1) % 14
        end
      end
    end

    return lines
  end

  # try_add_entry(entry, idx, lines) tries to put the hours for entry into
  # the lines array in index idx. This function returns a boolean indicating
  # whether the operation was successful. An entry will fit on a particular
  # day if the amount of time billed on that day so far (according to lines)
  # plus the hours billed on the entry to add is less than 24.
  def try_add_entry(entry, idx, lines)
    duration = entry.hours
    start_hours = entry.eventdate.startdate.hour + entry.eventdate.startdate.min/60.0
    return false if duration > 24
    # check if there is any entry on this day
    if lines[idx].nil?
      # if the start time plus the duration would put the end time on the
      # next day, adjust the times forward so the end time is at 24:00.
      if start_hours+duration > 24
        lines[idx] = [24 - duration, 24]
      else
        lines[idx] = [start_hours, start_hours + duration]
      end
    else
      # calculate how much time is currently billed on this day
      existing_duration = lines[idx][1] - lines[idx][0]
      return false if duration + existing_duration > 24
      # check if the entry we're adding starts before (2nd case) or after
      # (1st case) the entry already on this day
      if start_hours >= lines[idx][0]
        if lines[idx][1] + duration > 24
          lines[idx] = [24 - (duration + existing_duration), 24]
        else
          lines[idx][1] = lines[idx][0] + duration + existing_duration
        end
      else
        if start_hours + existing_duration + duration > 24
          lines[idx] = [24 - (duration + existing_duration), 24]
        else
          lines[idx] = [start_hours, start_hours + duration + existing_duration]
        end
      end
    end
    return true
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
end
