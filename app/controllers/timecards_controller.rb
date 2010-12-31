class TimecardsController < ApplicationController
	before_filter :login_required
	layout 'application2'

	def index
		@timecards = Timecard.find(:all)
	end

	def show
		@timecard = Timecard.find(params[:id])
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

end
