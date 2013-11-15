class InvoiceItemController < ApplicationController
  def index
    list
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  # verify :method => :post, :only => [ :destroy, :create, :update ],
  #       :redirect_to => { :action => :list }

  def list
    @invoice_items = InvoiceItem.all
    render :action=>'list', :layout=>"application2"
  end

  def new
    @invoice_items = InvoiceItem.new
    render :layout=>"application2"
  end

  def create
    @invoice_items = InvoiceItem.new(params[:invoice_items])
    if @invoice_items.save
      flash[:notice] = 'InvoiceItem was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new', :layout=>"application2"
    end
  end

  def edit
    @invoice_items = InvoiceItem.find(params[:id])
    render :layout=>"application2"
  end

  def update
    @invoice_items = InvoiceItem.find(params[:id])
    if @invoice_items.update_attributes(params[:invoice_items])
      flash[:notice] = 'InvoiceItem was successfully updated.'
      redirect_to :action => 'show', :id => @invoice_items
    else
      render :action => 'edit', :layout=>"application2"
    end
  end

  def destroy
    InvoiceItem.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
