class TimecardsController < ApplicationController
  before_filter :login_required

  def index
    @timecards = Timecard.find(:all, :order => 'billing_date DESC')
    @member = current_member
  end

  def show
    @timecard = Timecard.find(params[:id])
    @member = current_member
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
    @timecard = Timecard.find(params[:id])
    if params[:format] == 'pdf'
      headers['Content-Type'] = 'application/pdf'
      headers['Content-Disposition'] = "inline; filename=\"timecards-#{@timecard.billing_date.strftime("%Y-%m-%d")}.pdf\""
      render :layout => false, :action => 'print_collection'
    end
  end

  DAY = 24*60*60
  WEEK = 7*DAY
  def new
    @timecard = Timecard.new
    @timecard.billing_date = Timecard.latest_dates.billing_date + 2*WEEK
    @timecard.due_date = Timecard.latest_dates.billing_date + 2*WEEK - 2*DAY
    @timecard.start_date = Timecard.latest_dates.due_date
    @timecard.end_date = Timecard.latest_dates.due_date + 2*WEEK
  end

  def create
    @timecard = Timecard.new(params[:timecard])
    if @timecard.save
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end

  def edit
    @timecard = Timecard.find(params[:id])
  end

  def update
    @timecard = Timecard.find(params[:id])
    if @timecard.update_attributes(params[:timecard])
      flash[:notice] = 'Timecard updated successfully'
      redirect_to :action => 'view'
    else
      render :action => 'edit'
    end
  end

  def destroy
    @timecard = Timecard.find(params[:id])
    @timecard.destroy
    redirect_to :action => 'index'
  end
end
