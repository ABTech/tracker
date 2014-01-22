class InvoiceItemsController < ApplicationController
  before_filter :authenticate_member!
  
  layout "finance"

  def index
    @invoice_items = InvoiceItem.all
  end

  def new
    @invoice_item = InvoiceItem.new
  end

  def create
    @invoice_item = InvoiceItem.new(params[:invoice_item])
    if @invoice_item.save
      flash[:notice] = 'Invoice item was successfully created.'
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end

  def edit
    @invoice_item = InvoiceItem.find(params[:id])
  end

  def update
    @invoice_item = InvoiceItem.find(params[:id])
    if @invoice_item.update(params[:invoice_item])
      flash[:notice] = 'Invoice item was successfully updated.'
      redirect_to :action => 'index'
    else
      render :action => 'edit'
    end
  end

  def destroy
    InvoiceItem.find(params[:id]).destroy
    flash[:notice] = 'Invoice item was successfully deleted.'
    redirect_to :action => 'index'
  end
end
