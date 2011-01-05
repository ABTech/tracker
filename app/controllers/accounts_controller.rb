class AccountsController < ApplicationController
  before_filter :login_required;

  def index
    @accounts = Account.find(:all)
  end

  def show
    @account = Account.find(params[:id])
  end

  def new
    @account = Account.new
  end

  def edit
    @account = Account.find(params[:id])
  end

  def create
    @account = Account.new(params[:account])
    if @account.save
      flash[:notice] = 'Account was successfully created'
      redirect_to(:action => 'show')
    else
      render :action => 'new'
    end
  end

  def update
    @account = Account.find(params[:id])
    if @account.update_attributes(params[:account])
      flash[:notice] = 'Account was successfully updated'
      redirect_to(:action => 'show')
    else
      render :action => 'edit'
    end
  end

  def destroy
    @account = Account.find(params[:id])
    @account.destroy
    redirect_to :action => 'index'
  end

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
