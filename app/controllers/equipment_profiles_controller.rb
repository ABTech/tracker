class EquipmentProfilesController < ApplicationController
  def index
    authorize! :read, EquipmentProfile
    
    @title = "Equipment Profile"
    @categories = EquipmentProfile.categories.collect do |c|
      {
        :name => c,
        :children => EquipmentProfile.category(c),
        :subcategories => EquipmentProfile.subcategories(c).collect do |sc|
          {
            :name => sc,
            :children => EquipmentProfile.subcategory(c, sc)
          }
        end
      }
    end
  end
  
  def show
    @title = "Viewing Equipment Profile"
    @equipment_profile = EquipmentProfile.active.find(params[:id])
    authorize! :read, @equipment_profile
    
    respond_to do |format|
      format.html
      format.json do
        events = Eventdate.where("enddate > ? AND startdate < ? AND id IN (SELECT eventdate_id FROM equipment_profiles_eventdates WHERE equipment_profile_id = ?)",
          Date.parse(params[:start]), Date.parse(params[:end]), @equipment_profile.id).to_a.collect do |ed|
            {
              title: "#{ed.event.title} - #{ed.description}",
              start: ed.startdate,
              end: ed.enddate,
              url: event_url(ed.event)
            }
        end
        
        render json: events
      end
    end
  end
  
  def new
    @title = "New Equipment Profile"
    @equipment_profile = EquipmentProfile.new
    authorize! :create, @equipment_profile
  end
  
  def edit
    @title = "Editing Equipment Profile"
    @equipment_profile = EquipmentProfile.active.find(params[:id])
    authorize! :update, @equipment_profile
  end
  
  def create
    @equipment_profile = EquipmentProfile.new(equipment_profile_params)
    authorize! :create, @equipment_profile
    if @equipment_profile.save
      flash[:notice] = 'Equipment Profile was successfully created.'
      redirect_to equipment_profiles_url
    else
      render(:action => 'new')
    end
  end
  
  def update
    @equipment_profile = EquipmentProfile.active.find(params[:id])
    authorize! :update, @equipment_profile
    if @equipment_profile.update(equipment_profile_params)
      flash[:notice] = 'Equipment Profile was successfully updated.'
      redirect_to @equipment_profile
    else
      render(:action => 'edit')
    end
  end
  
  def destroy
    @equipment_profile = EquipmentProfile.active.find(params[:id])
    authorize! :destroy, @equipment_profile
    
    @equipment_profile.defunct = true
    if @equipment_profile.save
      flash[:notice] = "Equipment Profile \"#{@equipment_profile.description}\" has been marked as defunct."
    else
      flash[:error] = "Error marking equipment \"#{@equipment_profile.description}\" as defunct."
    end
    
    redirect_to equipment_profiles_url
  end
  
  private
    def equipment_profile_params
      params.require(:equipment_profile).permit(:description, :shortname, :category, :subcategory)
    end
  
end
