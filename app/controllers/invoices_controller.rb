class InvoicesController < ApplicationController
  load_and_authorize_resource :only => [:index, :new, :edit, :update, :destroy]
  helper_method :prettyViewPdfStr

  def show
    @title = "Viewing Invoice"

    @invoice = Invoice.includes(:event, :invoice_lines).find(params[:id])
    authorize! :show, @invoice

    render :layout => 'events'
  end

  def prettyView
    @invoice = Invoice.includes(:event, :invoice_lines).find(params[:id])
    authorize! :show, @invoice

    if params.include? :no_show_oracle
      @no_show_oracle = true
    end

    @title = "#{@invoice.event.title}-#{@invoice.status}#{@invoice.id}"
    respond_to do |format|
      format.html do
        render :layout=>false
      end
      format.pdf do
        pdf = prettyViewPdfStr
        if params.include? :download
          send_data pdf, filename: "#{@title}.pdf", type: 'application/pdf', disposition: 'attachment'
        else
          send_data pdf, filename: "#{@title}.pdf", type: 'application/pdf', disposition: 'inline'
        end
      end
    end
  end

  def new
    @title = "Create New Invoice"

    @invoice.status = "Quote"

    5.times do
      @invoice.invoice_lines.build
    end

    if params["event_id"]
      @invoice.event_id = params["event_id"]

      unless @invoice.event.current_year?
        flash[:error] = "This event is outside of the current billing year."

        redirect_to @invoice.event
      end
    end
  end

  def edit
    @title = "Edit Invoice"

    render :layout => 'events'
  end

  def create
    @title = "Create New Invoice"

    @invoice = Invoice.new(invoice_params)
    authorize! :create, @invoice

    if @invoice.save
      flash[:notice] = "Invoice created successfully!"
      redirect_to @invoice
    else
      render :new
    end
  end

  def update
    @title = "Edit Invoice"

    if @invoice.update(invoice_params(@invoice))
      flash[:notice] = "Invoice updated successfully!"

      if params[:redirect] == "event"
        redirect_to event_url(@invoice.event)
      elsif params[:redirect] == "index"
        redirect_to invoices_url(:page => params[:page])
      else
        redirect_to @invoice
      end
    else
      render :edit
    end
  end

  def duplicate
    @old_invoice = Invoice.includes(:event, :invoice_lines).find(params[:id])
    @invoice = @old_invoice.amoeba_dup
    
    authorize! :create, @invoice

    if @invoice.save
      flash[:notice] = "Invoice duplicated successfully!"
    else
      flash[:error] = "Error duplicating invoice! " + @invoice.errors.full_messages.to_sentence
    end
    redirect_to @invoice.event
  end

  def destroy
    @invoice.destroy

    if !@invoice.event.nil?
      redirect_to @invoice.event
    else
      redirect_to invoices_url
    end
  end

  def index
    @title = "Invoice List"

    @invoices = @invoices.includes(:event, :invoice_lines).paginate(:per_page => 50, :page => params[:page]).order("created_at DESC")

    if params[:page]
      @page = params[:page]
    else
      @page = 1
    end
  end

  def email_confirm
    @invoice = Invoice.find(params['id'])
    authorize! :email, @invoice

    @attach_title = "#{@invoice.event.title}-#{@invoice.status}#{@invoice.id}.pdf"
    @email_to =  @invoice.event.contactemail
    if @invoice.status == "Invoice"
      email_cc_list = InvoiceContact.pluck(:email) + InvoiceContact::PERMANENT_INVOICE_CONTACTS
      @email_cc = email_cc_list.join(",")
    else
      @email_cc = "abtech@andrew.cmu.edu"
      @invoice.event.tic.each do |tic|
        @email_cc += "," + tic.email
      end
    end

    if @invoice.status == "New" or @invoice.status == "Quote"
      @email_content = "Attached is the quote for your event with AB Tech.  Please check all information listed for accuracy, and reply with confirmation.  If you have any questions please let us know."
    elsif @invoice.status == "Contract"
      @email_content = "Attached is the quote for your event with AB Tech.  Please read the contract terms, and let us know if you have any questions.  Please reply with the signed contract attached, return the contract to 5000 Forbes Ave. UC Box 73. Pittsburgh, PA 15213, or fax to 412-268-5938 ATTN:  AB Tech."
    elsif @invoice.status == "Invoice"
      if @invoice.payment_type == "StuAct"
        @email_content = "Attached is the final invoice for your event with AB Tech.  If you have any questions please let us know.  Otherwise the total amount will automatically be deducted from your account by SLICE Finance (SLICEfinance@andrew.cmu.edu) within two weeks."
      elsif @invoice.payment_type == "Check"
        @email_content = "Attached is the final invoice for your event with AB Tech.  Please make all checks payable to Carnegie Mellon University, with AB Tech listed in the memo field. Checks should be sent to 5000 Forbes Ave. UC Box 73. Pittsburgh, PA 15213."
      elsif @invoice.payment_type == "Oracle"
        if @invoice.oracle_string.empty?
          @email_content = "Attached is the final invoice for your event with AB Tech.  We need your Oracle string to complete payment.  Please reply all to this email with your Oracle String and the total amount will automatically be deducted from your account by SLICE Finance (SLICEfinance@andrew.cmu.edu) within two weeks."
        else
          @email_content = "Attached is the final invoice for your event with AB Tech.  If you have any questions please let us know. Otherwise the total amount will automatically be deducted from your account by SLICE Finance (SLICEfinance@andrew.cmu.edu) within two weeks."
        end
      end
    elsif @invoice.status == "Received"
      @email_content = "Attached is the final invoice for your event with AB Tech.  We have received your payment, and this copy is for your reference only."
    elsif @invoice.status == "Loan Agreement"
      @email_content = "Attached is the loan agreement for your event with AB Tech.  Please read the contract terms, and let us know if you have any questions.  Please reply with the signed contract attached, return the contract to 5000 Forbes Ave. UC Box 73. Pittsburgh, PA 15213, or fax to 412-268-5938 ATTN:  AB Tech."
    end

    @email_content += "\n\nAB Tech believes that fostering dialog between our clients and ourselves both before and after an event is the best way to ensure the success of future events, as well as improve the relationship between our organizations. As such, we welcome any comments or complaints you may have about our services. Feedback may be directed to abtech@andrew.cmu.edu, or to (412) 268-2104."

    @email_subject = "[AB Tech Billing] #{@invoice.event.title}"

    respond_to do |format|
      format.js
    end
  end

  def email
    @invoice = Invoice.find(params['id'])
    authorize! :email, @invoice

    if params[:mark_billing]
      @invoice.event.status= Event::Event_Status_Billing_Pending
      @invoice.event.save!
    elsif params[:mark_complete]
      @invoice.event.status= Event::Event_Status_Event_Completed
      @invoice.event.save!
    end

    attachment = prettyViewPdfStr
    InvoiceMailer.invoice(@invoice,attachment,params).deliver_now
    flash[:notice] = "Email Sent"
    respond_to do |format|
      format.html {redirect_to @invoice}
    end
  end

  private
    def invoice_params(invoice=Invoice)
      if can? :manage, invoice
        params.require(:invoice).permit(:event_id, :status, :payment_type, :oracle_string, :memo, :invoice_lines_attributes => [:id, :line_no, :memo, :category, :price, :quantity, :notes, :_destroy])
      else
        if not Invoice::Invoice_Status_Group_Exec.include? params[:invoice][:status]
          params[:invoice].delete :status
        end

        params.require(:invoice).permit(:event_id, :status, :payment_type, :oracle_string, :memo, :invoice_lines_attributes => [:id, :line_no, :invoice, :memo, :category, :price, :quantity, :notes, :_destroy])
      end
    end

    def prettyViewPdfStr
      html = render_to_string :template=>'invoices/prettyView.html.erb', :layout=>false
      pdf = Grover.new(html,
                       format: 'Letter',
                       cache: false,
                       margin: { top: "0.5in", right: "0.5in", bottom: "0.5in", left: "0.5in" },
                       raise_on_request_failure: true
                      ).to_pdf
    end
end
