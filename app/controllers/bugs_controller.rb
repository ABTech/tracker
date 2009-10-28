class BugsController < ApplicationController
  layout 'application2'
  before_filter :login_required 

  def index
    @show_closed = true if params[:showclosed] == '1'
    if @show_closed
      @bugs = Bug.find(:all)
      render
    else
      #by default only load opened bugs
      @bugs = Bug.find(:all, :conditions => "closed != 1")
      render
    end
  end

  def new
    @bug = Bug.new
    @bug.member = current_member

    render :layout => false if params[:dialog]
  end

  def create
    @bug = Bug.new(params[:bug])
    @bug.member = current_member
    @bug.submitted_on = Time.now
    if @bug.save!
      flash[:notice] = "Thank you for your submission. That was bug number #{@bug.id}."
      redirect_to :controller => "event", :action => "list"
    else
      flash[:error] = "An error occured with your bug submission."
      render :action => "new"
    end
  end

  def edit
    @bug = Bug.find(params[:id])
  end

  def update
    @bug = Bug.find(params[:id])
    #Update resolved_on only if resolved_on was nil
    @bug.resolved_on = Time.now if @bug.resolved_on.nil? and params[:bug][:resolved] == "1"
    if @bug.update_attributes(params[:bug])
      flash[:notice] = "Bug was successfully updated."
      redirect_to :action => 'index'
    else 
      flash[:error] = "An error occured with your bug submission."
      render :action => "edit"
    end
  end

  def destroy
  end
end
