class TimecardsController < ApplicationController
  load_and_authorize_resource :except => :create
  
  def index
    @timecards = @timecards.order("billing_date DESC")
  end

  def show
    @member = current_member
    @past = current_member.timecards.where(submitted: true)
  end

  def view
  end

  def new
    interval = 1.week
    if not Timecard.latest_dates.nil?
      @timecard.billing_date = Timecard.latest_dates.billing_date + interval
      @timecard.due_date = Timecard.latest_dates.due_date + interval
      @timecard.start_date = Timecard.latest_dates.start_date + interval
      @timecard.end_date = Timecard.latest_dates.end_date + interval
    else
      @timecard.billing_date = Date.today + interval
      @timecard.due_date = Date.today + interval
      @timecard.start_date = Date.today
      @timecard.end_date = Date.today + interval
    end
  end

  def create
    @timecard = Timecard.new(timecard_params)
    authorize! :create, @timecard
    
    if @timecard.save
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    if @timecard.update(timecard_params)
      flash[:notice] = 'Timecard updated successfully'
      redirect_to :action => 'view'
    else
      render :action => 'edit'
    end
  end

  def destroy
    @timecard.destroy
    redirect_to :action => 'index'
  end
  
  private
    def timecard_params
      params.require(:timecard).permit(:billing_date, :due_date, :start_date, :end_date, :submitted)
    end
end
