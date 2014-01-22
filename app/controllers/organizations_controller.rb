class OrganizationsController < ApplicationController
  before_filter :authenticate_member!

  def index
    @title = "Organizations"
    @orgs = Organization.order("name ASC")
  end

  def new
    @title = "New Organization"
    @org = Organization.new
  end

  def create 
    @org = Organization.new(params[:organization])
    if @org.save
    	flash[:notice] = "Organization (#{@org.name}) was successfully created."
    	redirect_to organizations_url
    else
    	flash[:error] = "Organization could not be created."
    	render :action => "new"
    end
  end

  def show
    @org = Organization.find(params[:id])
    @title = "Organizations - #{@org.id}"
  end

  def edit
    @title = "Edit an Organization"
    @org = Organization.active.find(params[:id])
  end

  def update
    @org = Organization.active.find(params[:id])
    if @org.update_attributes(params[:organization])
      flash[:notice] = "Organization (#{@org.name}) was successfully updated."
	redirect_to(organizations_path)
    else
      render :action => "edit"
    end
  end

  def destroy 
    @org = Organization.active.find(params[:id])
    @org.defunct = true
    if @org.save
      flash[:notice] = "Organization \"#{@org.name}\" has been marked as defunct."
    else
      flash[:error] = "Error marking organization \"#{@org.name}\" as defunct."
    end
    
    redirect_to organizations_path
  end
end
