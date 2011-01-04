class AccountController < ApplicationController
  before_filter :login_required;

  scaffold :account;

    def list
        @title = "Chart of Accounts"
		
        @credit_accounts = Account.find(:all, :conditions => "is_credit = true")
		@debit_accounts = Account.find(:all, :conditions => "is_credit = false")
		
		@accounts_receivable_total = Journal.sum(:amount, :conditions => ["date > '" + Account::Magic_Date + "' AND date_paid IS NULL AND account_id in (?)", Account::Credit_Accounts]);
		@accounts_receivable_total = (@accounts_receivable_total == nil) ? 0 : @accounts_receivable_total;
		@accounts_received_total = Journal.sum(:amount, :conditions => ["date > '" + Account::Magic_Date + "' AND date_paid IS NOT NULL AND account_id in (?)", Account::Credit_Accounts]);
		@accounts_received_total = (@accounts_received_total == nil) ? 0 : @accounts_received_total;
		@accounts_payable_total = Journal.sum(:amount, :conditions => ["date > '" + Account::Magic_Date + "' AND date_paid IS NULL AND account_id in (?)", Account::Debit_Accounts]);
		@accounts_payable_total = (@accounts_payable_total == nil) ? 0 : @accounts_payable_total;
		@accounts_paid_total = Journal.sum(:amount, :conditions => ["date > '" + Account::Magic_Date + "' AND date_paid IS NOT NULL AND account_id in (?)", Account::Debit_Accounts]);
		@accounts_paid_total = (@accounts_paid_total == nil) ? 0 : @accounts_paid_total;
		
		@credit_JEs = Journal.find(:all, :conditions => ["date > '" + Account::Magic_Date + "' AND account_id in (?)", Account::Credit_Accounts], :order => "date DESC")
		@debit_JEs = Journal.find(:all, :conditions => ["date > '" + Account::Magic_Date + "' AND account_id in (?)", Account::Debit_Accounts], :order => "date DESC")
		
		render(:layout => "application2")
    end

    def view
        @title = "View Account"
        
        if(!params["id"])
            flash[:error] = "You must specify an ID.";
            render :action => 'list';
            return;
        end
        
        @account = Account.find(params["id"], :include => [:journals_credit, :journals_debit]);
        @journals = (@account.journals_credit | @account.journals_debit).sort_by{|p| p.date};
        @balance = @account.balance;
    end

    def events
        @title = "Completed Events Validation"
        @events = Event.find(:all, :include => [:invoices, :organization],
                :conditions => ["events.status IN (?) AND events.year_id = (?)", Event::Event_Status_Event_Completed, Year.active_year.id]);
    end

    def unpaid
        @title = "Unpaid JEs"

        @journals = Journal.find(:all, :conditions => ["date > '" + Account::Magic_Date + "' AND date_paid IS NULL"])
    end

    def unpaid_print
        @title = "Unpaid JEs"

        @journals = Journal.find(:all, :conditions => ["date > '" + Account::Magic_Date + "' AND date_paid IS NULL"])
    end

    def confirm_paid
        flash[:error] = "";
        date = params["date"];

        date.keys.each do |key|
            if(date[key].empty?)
                next;
            end

            rec = Journal.find(key.to_i());
            rec.date_paid = Date.parse(date[key], true);
			
            if(rec.valid?)
                rec.save();
            else
                rec.errors.each_full do |err|
                    flash[:error] = flash[:error] + "<br/>" + err;
                end
            end
        end
        redirect_to(:action => "unpaid");
    end
end
