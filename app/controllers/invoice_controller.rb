class InvoiceController < ApplicationController
  layout "finance"

  before_filter :login_required;

  #TODO: is this required?
  #require 'wicked_pdf'

  New_Invoice_New_Line_Display_Count = 5;
  Old_Invoice_New_Line_Display_Count = 5;

  def view
    @mode = Mode_View;
    @title = "Viewing Invoice";

    @invoice = Invoice.find(params['id'], :include => [:event, :journal_invoice, :invoice_lines]);

    render :action => 'record', :layout => 'events'
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

    render :action => 'record', :layout => 'events'
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
    flash[:notice] = nots if !nots.empty?
    flash[:error] = errs if !errs.empty?

    # --------------------
    # save invoice
    if(@invoice.save())
      flash[:notice] ||= ""
      flash[:notice] += "Invoice Saved";
      
      if params[:redirect] == "event"
        redirect_to event_url(@invoice.event)
      else
        redirect_to view_invoice_index_url(:id => @invoice.id)
      end
    else
      flash[:error] ||= ""
      @invoice.errors.each_full() do |err|
        flash[:error] += err + "<br />";
      end
      redirect_to edit_invoice_index_url(@invoice)
    end
  end

  def list
    @title = "Invoice List"
    
    @invoices = Invoice.includes(:event, :journal_invoice, :invoice_lines).paginate(:per_page => 50, :page => params[:page]).order("created_at DESC")
  end

  def email_confirm
    @invoice = Invoice.find(params['id'], :include => [:event]);
    @attach_title = "#{@invoice.event.title}-#{@invoice.status}#{@invoice.id}.pdf"
    if(@invoice.event.organization.org_email.nil?)
      @email_to=  @invoice.event.contactemail
    else
      @email_to=  @invoice.event.contactemail + ","+@invoice.event.organization.org_email
    end
    
    if @invoice.status == "Invoice"
      @email_cc= "ritac@andrew.cmu.edu,abtech+billing@andrew.cmu.edu"
    else
      @email_cc = "abtech@andrew.cmu.edu"
      if @invoice.event.tic
        @email_cc += "," + @invoice.event.tic.kerbid
      end
    end
    
    if @invoice.status == "New" or @invoice.status == "Quote"
      @email_content = "Attached is the quote for your event with AB Tech.  Please check all information listed for accuracy, and reply with confirmation.  If you have any questions please let us know."
    elsif @invoice.status == "Contract"
      @email_content = "Attached is the quote for your event with AB Tech.  Please read the contract terms, and let us know if you have any questions.  Please reply with the signed contract attached, return the contract to 5000 Forbes Ave. UC Box 73. Pittsburgh, PA 15213, or fax to 412-268-5938 ATTN:  AB Tech."
    elsif @invoice.status == "Invoice"
      if @invoice.payment_type == "StuAct"
        @email_content = "Attached is the final invoice for your event with AB Tech.  If you have any questions please let us know.  Otherwise the total amount will automatically be deducted from your account by Rita Ciccariello (ritac@andrew.cmu.edu) within two weeks."
      elsif @invoice.payment_type == "Check"
        @email_content = "Attached is the final invoice for your event with AB Tech.  Please make all checks payable to Carnegie Mellon University, with AB Tech listed in the memo field. Checks should be sent to 5000 Forbes Ave. UC Box 73. Pittsburgh, PA 15213."
      elsif @invoice.payment_type == "Oracle"
        if @invoice.oracle_string.empty?
          @email_content = "Attached is the final invoice for your event with AB Tech.  We need your Oracle string to complete payment.  Please reply all to this email with your Oracle String and the total amount will automatically be deducted from your account by Rita Ciccariello (ritac@andrew.cmu.edu) within two weeks."
        else
          @email_content = "Attached is the final invoice for your event with AB Tech.  If you have any questions please let us know. Otherwise the total amount will automatically be deducted from your account by Rita Ciccariello (ritac@andrew.cmu.edu) within two weeks."
        end
      end
    elsif @invoice.status == "Received"
      @email_content = "Attached is the final invoice for your event with AB Tech.  We have received your payment, and this copy is for your reference only."
    end
        
    @email_content += "\n\nAB Tech believes that fostering dialog between our clients and ourselves both before and after an event is the best way to ensure the success of future events, as well as improve the relationship between our organizations. As such, we welcome any comments or complaints you may have about our services. Feedback may be directed to abtech@andrew.cmu.edu, or to (412) 268-2104."
    
    @email_subject = "AB Tech Billing For #{@invoice.event.title}"   
    
    respond_to do |format|
      format.js
    end
  end
  def email
    @invoice = Invoice.find(params['id'], :include => [:event]);
    if(params['mark_completed'])
      journal = Journal.new
      journal.date = DateTime.now
      journal.memo=@invoice.event.organization.name + " - " + @invoice.event.title
      journal.account=Account::Events_Account
      journal.invoice=@invoice
      journal.amount=@invoice.total
      journal.save!
      @invoice.event.status= Event::Event_Status_Billing_Pending
      @invoice.event.save!
    end

    #You need the template line so it uses the .pdf version not the .html
    #version

    attachment=render_to_string :pdf=>"output", :template => 'invoice/prettyView.pdf.erb', :layout=>false
    InvoiceMailer.invoice(@invoice,attachment,params).deliver
    flash[:notice] = "Email Sent"
    respond_to do |format|
      format.html {redirect_to :action => "view", :id => params['id']}
    end
  end
end
