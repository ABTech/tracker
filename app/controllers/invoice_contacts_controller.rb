class InvoiceContactsController < ApplicationController
    load_and_authorize_resource :except => [:create]

    def index
      @title = "Invoice Contacts"
    end

    def new
      @title = "Create a new Invoice Contact"
    end

    def create
      @title = "Create a new Invoice Contact"
      @invoice_contact = InvoiceContact.new(invoice_contact_params)
      authorize! :create, @invoice_contact

      if @invoice_contact.save
        flash[:notice] = 'Invoice contact was successfully created.'
        redirect_to :action => 'index'
      else
        render :action => 'new'
      end
    end

    def edit
      @title = "Edit Invoice Contact"
    end

    def update
      @title = "Edit Invoice Contact"

      if @invoice_contact.update(invoice_contact_params)
        flash[:notice] = 'Invoice contact was successfully updated.'
        redirect_to :action => 'index'
      else
        render :action => 'edit'
      end
    end

    def destroy
      @invoice_contact.destroy
      flash[:notice] = 'Invoice contact was successfully deleted.'
      redirect_to :action => 'index'
    end

    private
      def invoice_contact_params
        params.require(:invoice_contact).permit(:email, :notes)
      end
end
