class AccountsController < ApplicationController
  layout "finance"
  
  load_and_authorize_resource :only => [:index, :show, :new, :edit, :update, :destroy]

  def index
    @title = "Account List"
  end

  def show
    @title = "Account Display"
  end

  def new
    @title = "Account List"
  end

  def edit
    @title = "Edit Account"
  end

  def create
    @account = Account.new(account_params)
    authorize! :create, @account
    
    if @account.save
      flash[:notice] = 'Account was successfully created'
      redirect_to(:action => 'index')
    else
      render :action => 'new'
    end
  end

  def update
    if @account.update_attributes(account_params)
      flash[:notice] = 'Account was successfully updated'
      redirect_to(:action => 'index')
    else
      render :action => 'edit'
    end
  end

  def destroy
    @account.destroy
    redirect_to :action => 'index'
  end

  def list
    authorize! :read, :finance
    
    @title = "Chart of Accounts"
    begin
      @accstart = Date.parse(params[:start]).to_s
    rescue
      @accstart = Account.magic_date
    end

    begin
      @accend = Date.parse(params[:end]).to_s
    rescue
      @accend = Account.future_magic_date
    end

    cat_filter="%"
    if !params[:category].nil?
      cat_filter=params[:category]
    end
    @credit_accounts = Account.where(is_credit: true)
    @debit_accounts = Account.where(is_credit: false)
    
    @accounts_receivable_total = Journal.where("date >= ? AND date < ? AND date_paid IS NULL AND account_id in (?) and paymeth_category LIKE ?", @accstart, @accend, Account::Credit_Accounts, cat_filter).sum(:amount)
    @accounts_received_total = Journal.where("date >= ? AND date < ? AND date_paid IS NOT NULL AND account_id in (?) and paymeth_category LIKE ?", @accstart, @accend, Account::Credit_Accounts, cat_filter).sum(:amount)
    @accounts_payable_total = Journal.where("date >= ? AND date < ? AND date_paid IS NULL AND account_id in (?) and paymeth_category LIKE ?", @accstart, @accend, Account::Debit_Accounts, cat_filter).sum(:amount)
    @accounts_paid_total = Journal.where("date >= ? AND date < ? AND date_paid IS NOT NULL AND account_id in (?) and paymeth_category LIKE ?", @accstart, @accend, Account::Debit_Accounts, cat_filter).sum(:amount)

    @credit_JEs = Journal.where("date >= ? AND date < ? AND account_id in (?) AND paymeth_category LIKE ?", @accstart, @accend, Account::Credit_Accounts, cat_filter)
    @debit_JEs = Journal.where("date >= ? AND date < ? AND account_id in (?) AND paymeth_category LIKE ?", @accstart, @accend, Account::Debit_Accounts, cat_filter)
  end

  def events
    authorize! :manage, :finance
    
    @title = "Completed Events Validation"
    @events = Event.includes(:eventdates, :invoices).where(["events.status IN (?)", Event::Event_Status_Event_Completed]).order("representative_date DESC").paginate(:per_page => 50, :page => params[:page])
  end

  def unpaid
    authorize! :manage, :finance
    
    @title = "Unpaid JEs"

    @journals = Journal.find(:all, :conditions => ["date >= '" + Account.magic_date + "' AND date_paid IS NULL"])
  end

  def unpaid_print
    authorize! :manage, :finance
    
    @title = "Unpaid JEs"

    @journals = Journal.find(:all, :conditions => ["date >= '" + Account.magic_date + "' AND date_paid IS NULL"])
  end

  def confirm_paid
    authorize! :manage, :finance
    
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
  
  private
    def account_params
      params.require(:account).permit(:name, :is_credit, :position)
    end
end
