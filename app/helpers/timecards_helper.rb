module TimecardsHelper
	def format_timecard_date( date )
		sprintf("%02d/%02d/%02d", date.mon, date.day, date.year % 100)
	end
end
