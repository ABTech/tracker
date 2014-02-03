class OrganizationsController < ApplicationController
  def index
    @title = "Organizations"
    authorize! :read, Organization
    @orgs = Organization.accessible_by(current_ability).order("name ASC")
  end

  def new
    @title = "New Organization"
    @org = Organization.new
    authorize! :create, @org
  end

  def create 
    @org = Organization.new(org_params)
    authorize! :create, @org
    
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
    authorize! :read, @org
    
    @title = "Organizations - #{@org.id}"
  end

  def edit
    @title = "Edit an Organization"
    
    @org = Organization.active.find(params[:id])
    authorize! :update, @org
  end

  def update
    @org = Organization.active.find(params[:id])
    authorize! :update, @org
    
    if @org.update_attributes(org_params)
      flash[:notice] = "Organization (#{@org.name}) was successfully updated."
      redirect_to(organizations_path)
    else
      render :action => "edit"
    end
  end

  def destroy 
    @org = Organization.active.find(params[:id])
    authorize! :destroy, @org
    
    @org.defunct = true
    if @org.save
      flash[:notice] = "Organization \"#{@org.name}\" has been marked as defunct."
    else
      flash[:error] = "Error marking organization \"#{@org.name}\" as defunct."
    end
    
    redirect_to organizations_path
  end
  
  private
    def org_params
      params.require(:organization).permit(:name)
    end
end
