class TimecardEntriesController < ApplicationController
	before_filter :login_required
	layout 'application2'

	def index
		@timecard_entries = TimecardEntry.find(:all, :conditions => { :member_id => current_member.id })
		@timecards = {}
		@timecard_entries.each do |timecard_entry|
			if @timecards[timecard_entry.timecard]
				@timecards[timecard_entry.timecard] << timecard_entry
			else
				@timecards[timecard_entry.timecard] = [timecard_entry]
			end
		end
		# @timecards is a hash from a timecard object to the timecard_entries
		# for this user. One of the keys in the hash might be nil.
		@timecard_list = @timecards.keys.sort do |a,b|
			if a.nil?
				-1
			elsif b.nil?
				1
			else
				b.due_date <=> a.due_date
			end
		end
	end

	def new
		@timecard_entry = TimecardEntry.new
		@timecard_entry.eventdate_id = params[:eventdate_id]
		@eventdates = Timecard.valid_eventdates
		@timecards = Timecard.valid_timecards
	end

	def create
		@timecard_entry = TimecardEntry.new(params[:timecard_entry])
		@timecard_entry.member = current_member
		@timecard_entry.payrate = current_member.payrate
		puts @timecard_entry
		if @timecard_entry.save
			flash[:notice] = "Timecard entry saved"
			redirect_to :action => :index
		else
			flash[:notice] = "Error saving entry"
			@eventdates = Timecard.valid_eventdates
			@timecards = Timecard.valid_timecards
			render :action => :new
		end
	end

	def edit
		@timecard_entry = TimecardEntry.find(params[:id])
		if @timecard_entry.member != current_member
			flash[:notice] = 'You cannot edit someone else\'s timecard!'
			redirect_to :action => :index and return
		end
		@eventdates = Timecard.valid_eventdates
		@timecards = Timecard.valid_timecards
	end

	def update
		@timecard_entry = TimecardEntry.find(params[:id])
		if @timecard_entry.member != current_member
			flash[:notice] = 'You cannot edit someone else\'s timecard!'
			redirect_to :action => :index and return
		end
		if (@timecard_entry.timecard.nil? or !@timecard_entry.timecard.submitted) and @timecard_entry.update_attributes(params[:timecard_entry])
			flash[:notice] = 'Timecard entry successfully updated.'
			redirect_to :action => :index and return
		else
			@eventdates = Timecard.valid_eventdates
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
