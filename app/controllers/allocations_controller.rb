class AllocationsController < ApplicationController
  load_and_authorize_resource :except => [:index, :create]
  layout "finance"
  
  def index
    @title = "Allocations"
    authorize! :index, Allocation
    
    @year = params[:year] || Date.today.fiscal_year
    @allocations = Allocation.where(year: @year).order(category: :asc)
  end
  
  def show
    @title = "Allocations - " + @allocation.line_item
  end

  def new
    @title = "Create new allocation"
  end

  def edit
    @title = "Edit allocation"
  end

  def create
    @allocation = Allocation.new(allocation_params)
    authorize! :create, @allocation
    
    @allocation.year = Date.today.fiscal_year
    if @allocation.save
      flash[:notice] = "Created allocation \"#{@allocation.line_item}\""
      redirect_to allocations_url
    else
      @title = "Create new allocation"
      render :action => :new
    end
  end

  def update
    if @allocation.update_attributes(allocation_params)
      flash[:notice] = "Updated allocation \"#{@allocation.line_item}\""
      redirect_to allocations_url
    else
      @title = "Edit allocation"
      render :action => :edit
    end
  end

  def destroy
    @allocation.destroy
    flash[:notice] = "Deleted allocation \"#{@allocation.line_item}\""
    redirect_to allocations_url
  end
  
  private
    def allocation_params
      params.require(:allocation).permit(:category, :object_code, :line_item, :budget, :year, :notes)
    end
end
