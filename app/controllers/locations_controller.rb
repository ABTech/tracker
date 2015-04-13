class LocationsController < ApplicationController
  def index
    authorize! :read, Location
    
    @title = "Locations"
    @locations = Location.active.accessible_by(current_ability).order("building ASC, room ASC")
  end

  def show
    @title = "Viewing Location"
    @location = Location.active.find(params[:id])
    authorize! :read, @location
  end

  def new
    @title = "New Location"
    @location = Location.new
    authorize! :create, @location
  end

  def create
    @location = Location.new(location_params)
    authorize! :create, @location
    if @location.save
      flash[:notice] = 'Location was successfully created.'
      redirect_to locations_url
    else
      render(:action => 'new')
    end
  end

  def edit
    @title = "Editing Location"
    @location = Location.active.find(params[:id])
    authorize! :update, @location
  end

  def update
    @location = Location.active.find(params[:id])
    authorize! :update, @location
    if @location.update_attributes(location_params)
      flash[:notice] = 'Location was successfully updated.'
      redirect_to @location
    else
      render(:action => 'edit')
    end
  end

  def destroy
    @location = Location.active.find(params[:id])
    authorize! :destroy, @location
    
    @location.defunct = true
    if @location.save
      flash[:notice] = "Location \"#{@location}\" has been marked as defunct."
    else
      flash[:error] = "Error marking location \"#{@location}\" as defunct."
    end
    
    redirect_to locations_url
  end
  
  private
    def location_params
      params.require(:location).permit(:building, :room, :details)
    end
end
