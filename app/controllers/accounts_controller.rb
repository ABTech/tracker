class AccountsController < ApplicationController
  layout "finance"

  def index
    @title = "Account List"

    @accounts = Account.find(:all)
  end

  def show
    @title = "Account Display"

    @account = Account.find(params[:id])
  end

  def new
    @title = "Account List"

    @account = Account.new
  end

  def edit
    @title = "Edit Account"

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
    begin
      @accstart = Date.parse(params[:start]).to_s
    rescue
      @accstart = Account::Magic_Date
    end

    begin
      @accend = Date.parse(params[:end]).to_s
    rescue
      @accend = Account::Future_Magic_Date
    end

    cat_filter="%"
    if !params[:category].nil?
      cat_filter=params[:category]
    end
    @credit_accounts = Account.find(:all, :conditions => "is_credit = true")
    @debit_accounts = Account.find(:all, :conditions => "is_credit = false")

    @accounts_receivable_total = Journal.sum(:amount, :conditions => ["date >= '" + @accstart+ "' AND date < '"+ @accend +"' AND date_paid IS NULL AND account_id in (?) and paymeth_category LIKE ?", Account::Credit_Accounts, cat_filter])
    @accounts_receivable_total = (@accounts_receivable_total == nil) ? 0 : @accounts_receivable_total
    @accounts_received_total = Journal.sum(:amount, :conditions => ["date >= '" + @accstart+ "' AND date < '"+ @accend +"'  AND date_paid IS NOT NULL AND account_id in (?) and paymeth_category LIKE ?", Account::Credit_Accounts, cat_filter])
    @accounts_received_total = (@accounts_received_total == nil) ? 0 : @accounts_received_total
    @accounts_payable_total = Journal.sum(:amount, :conditions => ["date >= '" + @accstart+ "'  AND date < '"+ @accend +"' AND date_paid IS NULL AND account_id in (?) and paymeth_category LIKE ?", Account::Debit_Accounts, cat_filter])
    @accounts_payable_total = (@accounts_payable_total == nil) ? 0 : @accounts_payable_total
    @accounts_paid_total = Journal.sum(:amount, :conditions => ["date >= '" + @accstart+ "' AND date < '"+ @accend +"'  AND date_paid IS NOT NULL AND account_id in (?) and paymeth_category LIKE ?", Account::Debit_Accounts, cat_filter])
    @accounts_paid_total = (@accounts_paid_total == nil) ? 0 : @accounts_paid_total

    @credit_JEs = Journal.find(:all, :conditions => ["date >= '" + @accstart+ "' AND date < '"+ @accend +"'  AND account_id in (?) and paymeth_category LIKE ?", Account::Credit_Accounts, cat_filter], :order => "date DESC")
    @debit_JEs = Journal.find(:all, :conditions => ["date >= '" + @accstart+ "' AND date < '"+ @accend +"'  AND account_id in (?) and paymeth_category LIKE ?", Account::Debit_Accounts, cat_filter], :order => "date DESC")
  end

  def events
    @title = "Completed Events Validation"
    @events = Event.includes(:eventdates, :invoices).where(["events.status IN (?)", Event::Event_Status_Event_Completed]).order("representative_date DESC").paginate(:per_page => 50, :page => params[:page])
  end

  def unpaid
    @title = "Unpaid JEs"

    @journals = Journal.find(:all, :conditions => ["date >= '" + Account::Magic_Date + "' AND date_paid IS NULL"])
  end

  def unpaid_print
    @title = "Unpaid JEs"

    @journals = Journal.find(:all, :conditions => ["date >= '" + Account::Magic_Date + "' AND date_paid IS NULL"])
  end

  def confirm_paid
    date = params["date"]
    
    completed = 0
    
    date.keys.each do |key|
      if(date[key].empty?)
        next
      end

      rec = Journal.find(key.to_i())
      begin
        rec.date_paid = Date.parse(date[key], true)
      rescue ArgumentError
        flash[:error] = "Invalid date for event #{rec.invoice.event.id}"
        redirect_to :action => "unpaid"
        return
      end

      if(rec.valid?)
        rec.save()
        completed += 1
      else
        flash[:error] ||= ""
        rec.errors.each_full do |err|
          flash[:error] = flash[:error] + "<br/>" + err
        end
      end
    end
    
    flash[:notice] = "#{completed} JEs marked as paid." if completed > 0

    redirect_to :action => "unpaid"
  end
end
