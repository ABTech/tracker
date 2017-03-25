class TimecardsController < ApplicationController
  load_and_authorize_resource :except => :create
  
  def index
    @timecards = @timecards.order("billing_date DESC")
  end

  def show
    @member = current_member
    @past = current_member.timecards.where(submitted: true)
    if params[:format] == 'txt'
      headers['Content-Type'] = 'text/plain'
      headers['Content-Disposition'] = 'inline'
      render :layout => false, :partial => 'formatted_timecard', :locals => { :timecard => @timecard, :member => @member}
    elsif params[:format] == 'pdf'
      headers['Content-Type'] = 'application/pdf'
      headers['Content-Disposition'] = "inline; filename=\"timecard-#{@member.fullname.gsub(/\s/, '-')}.pdf\""
      render :layout => false, :action => 'print'
    end
  end

  def view
    if params[:format] == 'pdf'
      headers['Content-Type'] = 'application/pdf'
      headers['Content-Disposition'] = "inline; filename=\"timecards-#{@timecard.billing_date.strftime("%Y-%m-%d")}.pdf\""
      render :layout => false, :action => 'print_collection'
    end
  end

  DAY = 24*60*60
  WEEK = 7*DAY
  def new
    @timecard.billing_date = Timecard.latest_dates.billing_date + 2*WEEK
    @timecard.due_date = Timecard.latest_dates.due_date + 2*WEEK
    @timecard.start_date = Timecard.latest_dates.start_date + 2*WEEK
    @timecard.end_date = Timecard.latest_dates.end_date + 2*WEEK
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
    if @timecard.update_attributes(timecard_params)
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
