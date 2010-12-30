class TimecardsController < ApplicationController
	before_filter :login_required
	layout 'application2'

	def index
		@timecards = Timecard.all
	end

	def show
		@timecard = Timecard.all[0]
		# @member = current_member
		# @end_date = Date.new(2010, 5, 9)
		# @due_date = Date.new(2010, 5, 7)
		headers['Content-Type'] = 'text/plain'
		headers['Content-Disposition'] = 'inline'
		render :layout => false
	end
end
