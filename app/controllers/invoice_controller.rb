class InvoiceController < ApplicationController

  before_filter :login_required;

  #TODO: is this required?
  #require 'wicked_pdf'

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
    headers['Content-Disposition'] = "inline;"
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

  def email_confirm
    @invoice = Invoice.find(params['id'], :include => [:event]);
    @attach_title = "#{@invoice.event.title}-#{@invoice.status}#{@invoice.id}.pdf"
    if(@invoice.event.organization.org_email.nil?)
      @email_to=  @invoice.event.contactemail
    else
      @email_to=  @invoice.event.contactemail + ","+@invoice.event.organization.org_email
    end
    @email_cc= "afasulo@andrew.cmu.edu,abtech+billing@andrew.cmu.edu"
    @email_subject ="AB Tech Billing For #{@invoice.event.title}"   
    @email_content="Attached is the final invoice for your event with AB Tech.  If you have any questions please let us know. Otherwise the total amount will automatically be deducted from your account by Abigail Fasulo (afasulo@andrew.cmu.edu) within two weeks.\n\nAB Tech believes that fostering dialog between our clients and ourselves both before and after an event is the best way to ensure the success of future events, as well as improve the relationship between our organizations. As such, we welcome any comments or complaints you may have about our services. Feedback may be directed to abtech@andrew.cmu.edu, or to (412) 268-2104."
    respond_to do |format|
      format.js
    end
  end
  def email
    @invoice = Invoice.find(params['id'], :include => [:event]);
    if(params['mark_completed'])
      journal = JeInv.new
      journal.date = DateTime.now
      journal.memo=@invoice.event.organization.name + " - " + @invoice.event.title
      journal.account=Account::Events_Account
      journal.invoice=@invoice
      journal.amount=@invoice.total
      journal.save!
      @invoice.event.status= Event::Event_Status_Event_Completed
      @invoice.event.save!
    end

    #You need the template line so it uses the .pdf version not the .html
    #version

    attachment=render_to_string :pdf=>"output", :template => 'invoice/prettyView.pdf.erb', :layout=>false
    InvoiceMailer.deliver_invoice(@invoice,attachment,params)
    flash[:notice] = "Email Sent"
    respond_to do |format|
      format.html {redirect_to :action => "view", :id => params['id']}
    end
  end
end
