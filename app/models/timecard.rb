class Timecard < ActiveRecord::Base
	# billing_date:datetime
	# due_date:datetime
	# submitted:boolean
	has_many :timecard_entries
	validates_presence_of :billing_date, :due_date
	validates_uniqueness_of :billing_date
	before_destroy :clear_entries

	def entries(member=nil)
		timecard_entries.select {|entry| member.nil? or entry.member == member } unless timecard_entries.nil?
	end

	def hours(member=nil)
		timecard_entries.inject(0) do |sum, entry|
			sum + ((member.nil? or member == entry.member) ? entry.hours : 0)
		end
	end

	def members
		TimecardEntry.find_by_sql("select distinct member_id from timecard_entries where timecard_id = #{id.to_i}").map {|e| e.member}
	end

	def self.latest_dates
		Timecard.find_by_sql('select billing_date,due_date from timecards order by billing_date DESC limit 1')[0]
	end

	def self.valid_timecards
		Timecard.find(:all).select {|timecard| !timecard.submitted }
	end

	def lines(member=nil)
		lines = Array.new(14)
		return if timecard_entries.nil?
		timecard_entries.each do |timecard_entry|
			next unless member.nil? or member == timecard_entry.member
			idx = ((billing_date - timecard_entry.eventdate.startdate)/(60*60*24) + 1).to_i % 14
			unless try_add_entry(timecard_entry, idx, lines)
				new_idx = (idx + 1) % 14
				while (new_idx != idx and !try_add_entry(timecard_entry, new_idx))
					new_idx = (new_idx + 1) % 14
				end
			end
		end
		return lines
	end

	def try_add_entry(entry, idx, lines)
		duration = entry.hours
		start_hours = entry.eventdate.startdate.hour + entry.eventdate.startdate.min/60.0
		return false if duration > 24
		if lines[idx].nil?
			if start_hours+duration > 24
				lines[idx] = [24 - duration, 24]
			else
				lines[idx] = [start_hours, start_hours + duration]
			end
		else
			existing_duration = lines[idx][1] - lines[idx][0]
			return false if duration + existing_duration > 24
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
					lines[idx] = [start_hours, duration + existing_duration]
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

end
