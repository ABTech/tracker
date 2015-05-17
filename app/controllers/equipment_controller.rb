class EquipmentController < ApplicationController
  def index
    authorize! :read, Equipment
    
    @title = "Equipment"
    @categories = Equipment.categories.collect do |c|
      {
        :name => c,
        :children => Equipment.category(c),
        :subcategories => Equipment.subcategories(c).collect do |sc|
          {
            :name => sc,
            :children => Equipment.subcategory(c, sc)
          }
        end
      }
    end
  end
  
  def show
    @title = "Viewing Equipment"
    @equipment = Equipment.active.find(params[:id])
    authorize! :read, @equipment
    
    respond_to do |format|
      format.html
      format.json do
        events = Eventdate.where("enddate > ? AND startdate < ? AND id IN (SELECT eventdate_id FROM equipment_eventdates WHERE equipment_id = ?)",
          Date.parse(params[:start]), Date.parse(params[:end]), @equipment.id).to_a.collect do |ed|
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
    @title = "New Equipment"
    @equipment = Equipment.new
    authorize! :create, @equipment
  end
  
  def edit
    @title = "Editing Equipment"
    @equipment = Equipment.active.find(params[:id])
    authorize! :update, @equipment
  end
  
  def create
    @equipment = Equipment.new(equipment_params)
    authorize! :create, @equipment
    if @equipment.save
      flash[:notice] = 'Equipment was successfully created.'
      redirect_to equipment_url
    else
      render(:action => 'new')
    end
  end
  
  def update
    @equipment = Equipment.active.find(params[:id])
    authorize! :update, @equipment
    if @equipment.update_attributes(equipment_params)
      flash[:notice] = 'Equipment was successfully updated.'
      redirect_to @equipment
    else
      render(:action => 'edit')
    end
  end
  
  def destroy
    @equipment = Equipment.active.find(params[:id])
    authorize! :destroy, @equipment
    
    @equipment.defunct = true
    if @equipment.save
      flash[:notice] = "Equipment \"#{@equipment}\" has been marked as defunct."
    else
      flash[:error] = "Error marking equipment \"#{@equipment}\" as defunct."
    end
    
    redirect_to equipment_url
  end
  
  private
    def equipment_params
      params.require(:equipment).permit(:description, :shortname, :category, :subcategory)
    end
  
end
