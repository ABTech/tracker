class LocationsController < ApplicationController
  
  before_filter :login_required

  def index
    @title = "Locations"
    @locations = Location.find(:all, :order => "building ASC, floor ASC")
  end

  def show
    @title = "Viewing Location"
    @location = Location.find(params[:id])
  end

  def new
    @title = "New Location"
    @location = Location.new
  end

  def create
    @location = Location.new(params[:location])
    if @location.save()
      flash[:notice] = 'Location was successfully created.'
      redirect_to locations_url
    else
      render(:action => 'new')
    end
  end

  def edit
    @title = "Editing Location"
    @location = Location.find(params[:id])
  end

  def update
    @location = Location.find(params[:id])
    if @location.update_attributes(params[:location])
      flash[:notice] = 'Location was successfully updated.'
      redirect_to @location
    else
      render(:action => 'edit')
    end
  end

  def destroy
    Location.find(params[:id]).destroy()
    redirect_to locations_url
  end
end
