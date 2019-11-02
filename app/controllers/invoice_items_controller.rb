class InvoiceItemsController < ApplicationController
  load_and_authorize_resource :except => [:create]

  def index
    @title = "Invoice Line Presets"
  end

  def new
    @title = "Create a new Invoice Line Preset"
  end

  def create
    @title = "Create a new Invoice Line Preset"
    @invoice_item = InvoiceItem.new(ii_params)
    authorize! :create, @invoice_item
    
    if @invoice_item.save
      flash[:notice] = 'Invoice item was successfully created.'
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end

  def edit
    @title = "Edit Invoice Line Preset"
  end

  def update
    @title = "Edit Invoice Line Preset"
    
    if @invoice_item.update(ii_params)
      flash[:notice] = 'Invoice item was successfully updated.'
      redirect_to :action => 'index'
    else
      render :action => 'edit'
    end
  end

  def destroy
    @invoice_item.destroy
    flash[:notice] = 'Invoice item was successfully deleted.'
    redirect_to :action => 'index'
  end
  
  private
    def ii_params
      params.require(:invoice_item).permit(:memo, :category, :price, :line_no)
    end
end
