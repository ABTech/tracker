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

# Handle only saving
        if params[:format]=='pdf' and params[:save]=="yes"
          @techlogo="file://#{RAILS_ROOT}/public/images/tech-with-fbnsal.png"
			render :pdf => @title, :layout => false,:save_to_file => "/home/joe/abtt/tmp/test.pdf", :save_only=> true
            redirect_to :action => "email", :id=>params['id']
#Handle creation of PDF and sending to browser
        elsif params[:format] == 'pdf'
          @techlogo="file://#{RAILS_ROOT}/public/images/tech-with-fbnsal.png"
			headers['Content-Type'] = 'application/pdf'
			headers['Content-Disposition'] = "inline; filename=\"test.pdf\""
			render :pdf => @title, :layout => false
        else

          @techlogo="/images/tech-with-fbnsal.png"
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

	@invoice = Invoice.find(params['id'], :include=>[:event,:journal_invoice,:invoice_lines]);
	@title = "#{@invoice.event.title}-#{@invoice.status}#{@invoice.event.id}"
		@title = "Create Invoice E-mail";

		@invoice = Invoice.find(params['id'], :include => [:event]);

		@outgoingemail = Email.new();
		@outgoingemail.timestamp = DateTime.now();
		@outgoing_destination = @invoice.event.contactemail;
		@outgoing_cc = "David Ruvolo <druvolo@andrew.cmu.edu>, abtech+billing@andrew.cmu.edu";
		@outgoing_from = "AB Tech Billing <abtech+billing@andrew.cmu.edu>";

		# if the old subject didn't have the eventid tag, add it
		@outgoingemail.subject = "AB Tech Invoice - #{@invoice.event.title}";

		date_string = @invoice.event.eventdates.collect{|dt| dt.startdate}.uniq().sort().last().strftime('%A, %B %d %Y');

		@outgoingemail.contents = <<EOM
Activities Board Technical Committee
Carnegie Mellon University

Event Invoice ##{@invoice.event.id}
Organization: #{@invoice.event.organization.name}
Event: #{@invoice.event.title}
Date: #{date_string}

Invoice for above event:
EOM
		tot_s = @invoice.total_sound;
		tot_l = @invoice.total_lighting;
		tot = @invoice.total;
		temp = 0;
		if(tot_s > 0)
			temp = temp + 1;
			@outgoingemail.contents << "Sound:\t\t$#{tot_s}\n";
		end
		if(tot_l > 0)
			temp = temp + 1;
			@outgoingemail.contents << "Lighting:\t$#{tot_l}\n";
		end
		@invoice.itemized_list.each do |line|
			temp = temp + 1;
			@outgoingemail.contents << "#{line.memo}:\t\t$#{line.total}\n";
		end
		if(temp > 1)
			@outgoingemail.contents << "Total:\t\t$#{tot}\n";
		end

		@outgoingemail.contents << "\n";

		if(@invoice.payment_type == "Oracle")
			@outgoingemail.contents << <<EOM
Oracle account: #{@invoice.oracle_string}

If there are no issues with this invoice the above amount will automatically be transfered from the above listed Oracle account by David Ruvolo <druvolo@andrew.cmu.edu> in 2 weeks.
EOM
		elsif (@invoice.payment_type == "Check")
			@outgoingemail.contents << <<EOM
Payment should be made in the form of a check or money order made out to "Carnegie Mellon (AB Tech)".
Please reference the invoice number (#{@invoice.event.id}) on the check.
Checks may be delivered in one of three ways:

1) via Campus or US Postal mail to:
   AB Tech
   Carnegie Mellon University
   University Center Box 73
   5032 Forbes Ave.
   Pittsburgh, PA 15213
2) via the University Center Info Desk, in an envelope marked
   "UC Box 73", or
3) personally to any of the people listed below:
   AB Tech Co-Chair, Jeff Grafton
   AB Tech Co-Chair, Matt Williamson
EOM
		else
			@outgoingemail.contents << <<EOM
If there are no issues with this invoice the above amount will automatically be transfered from your Student Activities Oracle account by David Ruvolo <druvolo@andrew.cmu.edu> in 2 weeks.
EOM
		end

		@outgoingemail.contents << <<EOM

AB Tech believes that fostering dialog between our clients and ourselves both before and after an event is the best way to ensure the success of future events, as well as improve the relationship between our organizations. As such, we welcome any comments or complaints you may have about our services. Feedback may be directed to abtech+@andrew.cmu.edu, or to (412) 268-2104.

Thank you,
Activities Board Technical Committee
______________________________________________________________________
abtech -- 412-268-2104 -- 412-268-7900 (FAX) -- AB Technical Committee
EOM

		render("email/reply_to");
	end

end
