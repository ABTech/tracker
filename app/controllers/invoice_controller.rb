class InvoiceController < ApplicationController
	before_filter :login_required;

    require 'wicked_pdf'

	New_Invoice_New_Line_Display_Count = 5;
	Old_Invoice_New_Line_Display_Count = 5;

	def view
		@mode = Mode_View;
		@title = "Viewing Invoice";

		@invoice = Invoice.find(params['id'], :include => [:event, :journal_invoice, :invoice_lines]);

		render :action => 'record'
	end

	def prettyView

	@invoice = Invoice.find(params['id'], :include=>[:event,:journal_invoice,:invoice_lines]);
	@title = "#{@invoice.event.title}-#{@invoice.status}#{@invoice.id}"

  if params[:format] == 'pdf'
    headers['Content-Type'] = 'application/pdf'
    headers['Content-Disposition'] = "inline; filename=\"test.pdf\""
    render :pdf => @title, :layout => false
  else
    render :layout=>false
  end
  end

	def new
		@title = "Create New Invoice";
		@mode = Mode_New;

		@invoice = InvoiceHelper.generate_new_invoice();
		if(params["event_id"])
			@invoice.event_id = params["event_id"];
		end

		render :action => 'record'
	end

	def edit
		@title = "Edit Invoice";
		@mode = Mode_Edit;

		if(!@invoice)
			if(!params["id"])
				flash[:error] = "You must specify an ID.";
				render :action => 'list'
				return;
			end
			
			@invoice = Invoice.find(params["id"]);
			if(!@invoice)
				flash[:error] = "Invoice #{params['id']} not found."
				render :action => 'list'
				return;
			end
		end

		Old_Invoice_New_Line_Display_Count.times do
			ln = InvoiceLine.new();
			@invoice.invoice_lines << ln;
		end

		render :action => 'record'
	end

	def create
		# --------------------
		# create new invoice/find old invoice
		if(params["invoice"]["id"] && (params["invoice"]["id"] != ""))
			@invoice = Invoice.update(params["invoice"]["id"], params['invoice']);
		else
			@invoice = Invoice.create(params['invoice']);
		end

		nots, errs = InvoiceHelper.update_invoice(@invoice, params);
		flash[:notice] = nots;
		flash[:error] = errs;

		# --------------------
		# save invoice
		if(@invoice.save())
			flash[:notice] += "Invoice Saved";
		else
			@invoice.errors.each_full() do |err|
				flash[:error] += err + "<br />";
			end
		end

		redirect_to(:action => "edit", :id => @invoice.id);
	end

	def list
		@title = "Invoice List";

		@invoices = Invoice.find(:all, :include => [:event, :journal_invoice, :invoice_lines]);
	end

	def email
		@invoice = Invoice.find(params['id'], :include => [:event]);
    #You need the template line so it uses the .pdf version not the .html
    #version
    attachment=render_to_string :pdf=>"output", :template => 'invoice/prettyView.pdf.erb', :layout=>false
    InvoiceMailer.deliver_invoice(@invoice,attachment)
    flash[:notice] = "Email Sent"
    redirect_to :action => "view", :id => params['id']
	end

end
