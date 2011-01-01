class TimecardEntriesController < ApplicationController
	before_filter :login_required
	layout 'application2'

	def index
		@timecard_entries = TimecardEntry.find(:all, :conditions => { :member_id => current_member.id })
	end

	def new
		@timecard_entry = TimecardEntry.new
		@timecard_entry.eventdate_id = params[:eventdate_id]
		@eventdates = TimecardEntry.valid_eventdates
		@timecards = Timecard.valid_timecards
	end

	def create
		@timecard_entry = TimecardEntry.new(params[:timecard_entry])
		@timecard_entry.member = current_member
		puts @timecard_entry
		if @timecard_entry.save
			flash[:notice] = "Timecard entry saved"
			redirect_to :action => :index
		else
			flash[:notice] = "Error saving entry"
			@eventdates = TimecardEntry.valid_eventdates
			@timecards = Timecard.valid_timecards
			render :action => :new
		end
	end

	def edit
		@timecard_entry = TimecardEntry.find(params[:id])
		@eventdates = TimecardEntry.valid_eventdates
		@timecards = Timecard.valid_timecards
	end

	def update
		@timecard_entry = TimecardEntry.find(params[:id])
		if (@timecard_entry.timecard.nil? or !@timecard_entry.timecard.submitted) and @timecard_entry.update_attributes(params[:timecard_entry])
			flash[:notice] = 'Timecard entry successfully updated.'
			redirect_to :action => :index
		else
			@eventdates = TimecardEntry.valid_eventdates
			@timecards = Timecard.valid_timecards
			render :action => :edit
		end
	end

	def destroy
		@timecard_entry = TimecardEntry.find(params[:id])
		@timecard_entry.destroy
		redirect_to :action => :index
	end
end
