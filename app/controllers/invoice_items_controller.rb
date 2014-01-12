class InvoiceItemsController < ApplicationController
  layout "finance"

  def index
    list
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  # verify :method => :post, :only => [ :destroy, :create, :update ],
  #       :redirect_to => { :action => :list }

  def list
    @invoice_items = InvoiceItem.all
    render :action=>'list'
  end

  def new
    @invoice_item = InvoiceItem.new
  end

  def create
    @invoice_item = InvoiceItem.new(params[:invoice_item])
    if @invoice_item.save
      flash[:notice] = 'Invoice item was successfully created.'
      redirect_to :action => 'list'
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
      redirect_to :action => 'list'
    else
      render :action => 'edit'
    end
  end

  def destroy
    InvoiceItem.find(params[:id]).destroy
    flash[:notice] = 'Invoice item was successfully deleted.'
    redirect_to :action => 'list'
  end
end
