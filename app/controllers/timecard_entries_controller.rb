class TimecardEntriesController < ApplicationController
	before_filter :login_required
	layout 'application2'

	def index
		@timecard_entries = TimecardEntry.find(:all)
	end

	def new
		@timecard_entry = TimecardEntry.new
		@timecard_entry.event_id = params[:event_id]
		@events = TimecardEntry.valid_events.collect { |e| [e.title, e.id]}
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
			@events = TimecardEntry.valid_events.collect { |e| [e.title, e.id]}
			render :action => :new
		end
	end

	def edit
		@timecard_entry = TimecardEntry.find(params[:id])
		@events = TimecardEntry.valid_events.collect { |e| [e.title, e.id]}
	end

	def update
		@timecard_entry = TimecardEntry.find(params[:id])
		if @timecard_entry.update_attributes(params[:timecard_entry])
			flash[:notice] = 'Timecard entry successfully updated.'
			redirect_to :action => :index
		else
			@events = TimecardEntry.valid_events.collect { |e| [e.title, e.id]}
			render :action => :edit
		end
	end

	def destroy
		@timecard_entry = TimecardEntry.find(params[:id])
		@timecard_entry.destroy
		redirect_to :action => :index
	end
end
