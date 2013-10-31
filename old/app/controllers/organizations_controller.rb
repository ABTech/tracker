class OrganizationsController < ApplicationController
    before_filter :login_required;

    layout "application2"

    def index
      @title = "Organizations"
      @orgs = Organization.find(:all)
    end

    def new
      @title = "New Organization"
      @org = Organization.new
    end

    def create 
      @org = Organization.new(params[:organization])
      if @org.save
	flash[:notice] = "Organization (#{@org.name}) was successfully created."
	redirect_to('/organizations')
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
      @org = Organization.find(params[:id])
    end

    def update
      @org = Organization.find(params[:id])
      if @org.update_attributes(params[:organization])
        flash[:notice] = "Organization (#{@org.name}) was successfully updated."
	redirect_to(organizations_path)
      else
        render :action => "edit"
      end
    end

  def destroy 
    @org = Organization.find(params[:id])
    @org.destroy
    redirect_to organizations_path
  end
end
