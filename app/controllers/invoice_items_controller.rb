class InvoiceItemsController < ApplicationController
	def index
		list
	end

	# GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
	verify :method => :post, :only => [ :destroy, :create, :update ],
				 :redirect_to => { :action => :list }

	def list
		@invoice_items_pages, @invoice_items = paginate :invoice_items, :per_page => 100
		render :action=>'list', :layout=>"application2"
	end

	def show
		@invoice_items = InvoiceItems.find(params[:id])
		render :layout=>"application2"
	end

	def new
		@invoice_items = InvoiceItems.new
		render :layout=>"application2"
	end

	def create
		@invoice_items = InvoiceItems.new(params[:invoice_items])
		if @invoice_items.save
			flash[:notice] = 'InvoiceItems was successfully created.'
			redirect_to :action => 'list'
		else
			render :action => 'new', :layout=>"application2"
		end
	end

	def edit
		@invoice_items = InvoiceItems.find(params[:id])
		render :layout=>"application2"
	end

	def update
		@invoice_items = InvoiceItems.find(params[:id])
		if @invoice_items.update_attributes(params[:invoice_items])
			flash[:notice] = 'InvoiceItems was successfully updated.'
			redirect_to :action => 'show', :id => @invoice_items
		else
			render :action => 'edit', :layout=>"application2"
		end
	end

	def destroy
		InvoiceItems.find(params[:id]).destroy
		redirect_to :action => 'list'
	end
end
