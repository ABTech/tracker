# This class is not directly backed by the database.
class Timecard
	attr_accessor :timecard_entries
	attr_reader :date, :timecard_lines, :member

	def self.all
		pairs = TimecardEntry.find_by_sql('select distinct member_id, billed from timecard_entries where billed is not null')
		pairs.map {|p| Timecard.new(p.member, p.billed) }
	end

	def initialize(member, date=nil)
		@timecard_entries = TimecardEntry.find(:all, :conditions => {:member_id => member.id, :billed => date})
		@member = member
		@timecard_lines = Array.new(14)
		# @timecard_lines is a two-dimensional array of integers representing
		# the start and end hours for that day (indicated by the first index)
		self.date= date
	end

	def hours
		@timecard_lines.inject(0) {|sum, pair|
			if pair.nil?
				sum
			else
				sum + pair[1] - pair[0]
			end
		}
	end

	def date=(d)
		return if d.nil?
		# sets the date in this object, fills timecard_lines, and adds the date
		# to the timecard_entry objects
		@date = d
		@timecard_entries.each do |timecard_entry|
			idx = ((@date - timecard_entry.eventdate.startdate)/(60*60*24) + 1).to_i % 14
			unless try_add_entry(timecard_entry, idx)
				new_idx = (idx + 1) % 14
				while (new_idx != idx and !try_add_entry(timecard_entry, new_idx))
					new_idx = (new_idx + 1) % 14
				end
			end
		end
	end

	private
	def try_add_entry(entry, idx)
		duration = entry.hours
		start_hours = entry.eventdate.startdate.hour + entry.eventdate.startdate.min/60.0
		return false if duration > 24
		if @timecard_lines[idx].nil?
			if start_hours+duration > 24
				@timecard_lines[idx] = [24 - duration, 24]
			else
				@timecard_lines[idx] = [start_hours, start_hours + duration]
			end
		else
			existing_duration = @timecard_lines[idx][1] - @timecard_lines[idx][0]
			return false if duration + existing_duration > 24
			if start_hours >= @timecard_lines[idx][0]
				if @timecard_lines[idx][1] + duration > 24
					@timecard_lines[idx][1] = 24
					@timecard_lines[idx][0] = 24 - (duration + existing_duration)
				else
					@timecard_lines[idx][1] = @timecard_lines[idx][0] + duration + existing_duration
				end
			else
				if start_hours + existing_duration + duration > 24
					@timecard_lines[idx][1] = 24
					@timecard_lines[idx][0] = 24 - (duration + existing_duration)
				else
					@timecard_lines[idx][0] = start_hours
					@timecard_lines[idx][1] = duration + existing_duration
				end
			end
		end
		if entry.billed.nil?
			entry.billed = @date
			entry.save
		end
		return true
	end #try_add_entry
end #class
