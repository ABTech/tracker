class BlackoutsController < ApplicationController
  load_and_authorize_resource :except => [:create]
  
  def index
    @title = "List of Blackouts"
    @blackouts = @blackouts.order("enddate DESC")
  end

  def new
    @title = "Create a Blackout"
  end

  def create
    @title = "Create a Blackout"
    @blackout = Blackout.new(blackout_params)
    authorize! :create, @blackout
    
    if @blackout.save
      flash[:notice] = "Blackout created successfully."
      redirect_to blackouts_url
    else
      render :new
    end
  end

  def edit
    @title = "Editing Blackout"
  end

  def update
    @title = "Editing Blackout"
    
    if @blackout.update(blackout_params)
      flash[:notice] = "Blackout updated successfully."
      redirect_to blackouts_url
    else
      render :edit
    end
  end

  def destroy
    @blackout.destroy
    flash[:notice] = "Blackout deleted successfully."
    redirect_to blackouts_url
  end
  
  private
    def blackout_params
      params.require(:blackout).permit(:title, :event_id, :startdate, :enddate)
    end
end
