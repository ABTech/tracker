class TimecardEntriesController < ApplicationController
  before_filter :authenticate_member!

  def index
    @pending = TimecardEntry.where(member_id: current_member.id, timecard_id: nil)
    @timecards = Timecard.where(submitted: false)
    @past = TimecardEntry.where(["member_id = ? AND timecard_id IS NOT NULL", current_member.id]).flat_map(&:timecard).uniq.select(&:submitted)
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
