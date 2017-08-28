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
    
    @org = Organization.find(params[:id])
    authorize! :update, @org
  end

  def update
    @org = Organization.find(params[:id])
    authorize! :update, @org
    
    if @org.update_attributes(org_params)
      flash[:notice] = "Organization (#{@org.name}) was successfully updated."
      redirect_to(organizations_path)
    else
      render :action => "edit"
    end
  end

  def destroy 
    @org = Organization.find(params[:id])
    authorize! :destroy, @org
    
    if @org.events.empty?
      @org.destroy
      
      if @org.save
        flash[:notice] = "Organization \"#{@org.name}\" has been deleted."
      else
        flash[:error] = "Error deleting organization \"#{@org.name}\"."
      end
      
      redirect_to organizations_path
    else
      flash[:error] = "You cannot delete an organization that has events."
      redirect_to @org
    end
  end
  
  private
    def org_params
      if can? :destroy, @org
        params.require(:organization).permit(:name, :defunct)
      else
        params.require(:organization).permit(:name)
      end
    end
end
