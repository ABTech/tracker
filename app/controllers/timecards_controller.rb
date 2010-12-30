class TimecardsController < ApplicationController
	before_filter :login_required
	layout 'application2'

	def index
		@timecards = Timecard.all_from_member(current_member)
	end

	def show
		@timecard = Timecard.new(current_member, TimecardsController::id_to_time(params[:id]))
		if params[:format] == 'txt'
			headers['Content-Type'] = 'text/plain'
			headers['Content-Disposition'] = 'inline'
			render :layout => false, :partial => 'timecard', :object => @timecard
		elsif params[:format] == 'pdf'
			headers['Content-Type'] = 'application/pdf'
			headers['Content-Disposition'] = 'inline'
			render :layout => false, :action => 'print'
		end
			
	end

	private
	def self.id_to_time(id)
		id = id.to_i
		Time.local(id/10000, (id/100)%100, id % 100)
	end
end
