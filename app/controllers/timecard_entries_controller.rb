class TimecardEntriesController < ApplicationController
  def index
    authorize! :index, TimecardEntry
    
    @pending = TimecardEntry.where(member_id: current_member.id, timecard_id: nil)
    @timecards = Timecard.where(submitted: false)
    @past = current_member.timecards.where(submitted: true)
  end

  def new
    @timecard_entry = TimecardEntry.new
    @timecard_entry.member = current_member
    authorize! :create, @timecard_entry
    
    @timecard_entry.eventdate_id = params[:eventdate_id]
    @eventdates = Timecard.valid_eventdates
    @timecards = Timecard.valid_timecards
  end

  def create
    @timecard_entry = TimecardEntry.new(timecard_entry_params)
    @timecard_entry.member = current_member
    @timecard_entry.payrate = current_member.payrate
    authorize! :create, @timecard_entry
    
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
    authorize! :update, @timecard_entry
    
    if not @timecard_entry.timecard.nil? and @timecard_entry.timecard.submitted
      flash[:error] = "You cannot edit submitted timecards."
      redirect_to :action => :index and return
    end

    @eventdates = Timecard.valid_eventdates
    @timecards = Timecard.valid_timecards
  end

  def update
    @timecard_entry = TimecardEntry.find(params[:id])
    authorize! :update, TimecardEntry
    
    if not @timecard_entry.timecard.nil? and @timecard_entry.timecard.submitted
      flash[:error] = "You cannot edit submitted timecards."
      redirect_to :action => :index
    end
    
    if @timecard_entry.update(timecard_entry_params)
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
    authorize! :destroy, @timecard_entry
    
    @timecard_entry.destroy
    redirect_to :action => :index
  end
  
  private
    def timecard_entry_params
      params.require(:timecard_entry).permit(:hours, :eventdate_id, :timecard_id)
    end
end
