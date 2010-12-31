class Timecard < ActiveRecord::Base
	# member_id:integer
	# billing_date:datetime
	# due_date:datetime
	# submitted:boolean
	has_many :timecard_entries
	validates_presence_of :member_id, :billing_date, :due_date
	attr_reader :date, :timecard_lines, :member

	def hours
		lines.inject(0) {|sum, pair|
			if pair.nil?
				sum
			else
				sum + pair[1] - pair[0]
			end
		}
	end

	def lines
		fill_timecard_lines if @lines.nil?
		@lines
	end

	private
	def fill_timecard_lines
		@lines = Array.new(14)
		return if timecard_entries.nil?
		timecard_entries.each do |timecard_entry|
			idx = ((billing_date - timecard_entry.eventdate.startdate)/(60*60*24) + 1).to_i % 14
			unless try_add_entry(timecard_entry, idx)
				new_idx = (idx + 1) % 14
				while (new_idx != idx and !try_add_entry(timecard_entry, new_idx))
					new_idx = (new_idx + 1) % 14
				end
			end
		end
	end

	def try_add_entry(entry, idx)
		duration = entry.hours
		start_hours = entry.eventdate.startdate.hour + entry.eventdate.startdate.min/60.0
		return false if duration > 24
		if @lines[idx].nil?
			if start_hours+duration > 24
				@lines[idx] = [24 - duration, 24]
			else
				@lines[idx] = [start_hours, start_hours + duration]
			end
		else
			existing_duration = @lines[idx][1] - @lines[idx][0]
			return false if duration + existing_duration > 24
			if start_hours >= @lines[idx][0]
				if @lines[idx][1] + duration > 24
					@lines[idx][1] = 24
					@lines[idx][0] = 24 - (duration + existing_duration)
				else
					@lines[idx][1] = @lines[idx][0] + duration + existing_duration
				end
			else
				if start_hours + existing_duration + duration > 24
					@lines[idx][1] = 24
					@lines[idx][0] = 24 - (duration + existing_duration)
				else
					@lines[idx][0] = start_hours
					@lines[idx][1] = duration + existing_duration
				end
			end
		end
		return true
	end #try_add_entry
end #class
