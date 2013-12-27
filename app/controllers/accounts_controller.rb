class AccountsController < ApplicationController
  layout "application2"
  
  before_filter :login_required

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
    begin
      @start = Date.parse(params[:start]).to_s
    rescue
      @start = Account::Magic_Date
    end

    begin
      @end = Date.parse(params[:end]).to_s
    rescue
      @end = Account::Future_Magic_Date
    end

    cat_filter="%"
    if !params[:category].nil?
      cat_filter=params[:category]
    end
    @credit_accounts = Account.find(:all, :conditions => "is_credit = true")
    @debit_accounts = Account.find(:all, :conditions => "is_credit = false")

    @accounts_receivable_total = Journal.sum(:amount, :conditions => ["date > '" + @start+ "' AND date < '"+ @end +"' AND date_paid IS NULL AND account_id in (?) and paymeth_category LIKE ?", Account::Credit_Accounts, cat_filter])
    @accounts_receivable_total = (@accounts_receivable_total == nil) ? 0 : @accounts_receivable_total
    @accounts_received_total = Journal.sum(:amount, :conditions => ["date > '" + @start+ "' AND date < '"+ @end +"'  AND date_paid IS NOT NULL AND account_id in (?) and paymeth_category LIKE ?", Account::Credit_Accounts, cat_filter])
    @accounts_received_total = (@accounts_received_total == nil) ? 0 : @accounts_received_total
    @accounts_payable_total = Journal.sum(:amount, :conditions => ["date > '" + @start+ "'  AND date < '"+ @end +"' AND date_paid IS NULL AND account_id in (?) and paymeth_category LIKE ?", Account::Debit_Accounts, cat_filter])
    @accounts_payable_total = (@accounts_payable_total == nil) ? 0 : @accounts_payable_total
    @accounts_paid_total = Journal.sum(:amount, :conditions => ["date > '" + @start+ "' AND date < '"+ @end +"'  AND date_paid IS NOT NULL AND account_id in (?) and paymeth_category LIKE ?", Account::Debit_Accounts, cat_filter])
    @accounts_paid_total = (@accounts_paid_total == nil) ? 0 : @accounts_paid_total

    @credit_JEs = Journal.find(:all, :conditions => ["date > '" + @start+ "' AND date < '"+ @end +"'  AND account_id in (?) and paymeth_category LIKE ?", Account::Credit_Accounts, cat_filter], :order => "date DESC")
    @debit_JEs = Journal.find(:all, :conditions => ["date > '" + @start+ "' AND date < '"+ @end +"'  AND account_id in (?) and paymeth_category LIKE ?", Account::Debit_Accounts, cat_filter], :order => "date DESC")

    @credit_categories = Journal.find(:all,:group=>"paymeth_category",:select=>"SUM(amount) AS amount, id,paymeth_category", :conditions => ["date > '#{@start}' AND date < '#{@end}' AND account_id in (?)",Account::Credit_Accounts])
    @debit_categories = Journal.find(:all,:group=>"paymeth_category",:select=>"SUM(amount) AS amount, id,paymeth_category", :conditions => ["date > '#{@start}' AND date < '#{@end}' AND account_id in (?)",Account::Debit_Accounts])
    @cat_totals = Hash.new(0)

    @credit_categories.each do |category|
      @cat_totals[category.paymeth_category]+=category.amount
    end

    @debit_categories.each do |category|
      @cat_totals[category.paymeth_category]-=category.amount
    end

    render(:layout => "application2")
  end

  def view
    @title = "View Account"

    if(!params["id"])
      flash[:error] = "You must specify an ID."
      render :action => 'list'
      return
    end

    @account = Account.find(params["id"], :include => [:journals_credit, :journals_debit])
    @journals = (@account.journals_credit | @account.journals_debit).sort_by{|p| p.date}
    @balance = @account.balance
  end

  def events
    @title = "Completed Events Validation"
    @events = Event.where(["events.status IN (?)", Event::Event_Status_Event_Completed]).all
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
    flash[:error] = ""
    date = params["date"]

    date.keys.each do |key|
      if(date[key].empty?)
        next
      end

      rec = Journal.find(key.to_i())
      rec.date_paid = Date.parse(date[key], true)

      if(rec.valid?)
        rec.save()
      else
        rec.errors.each_full do |err|
          flash[:error] = flash[:error] + "<br/>" + err
        end
      end
    end

    redirect_to(:action => "unpaid")
  end
end
