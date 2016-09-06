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
  end

  def events
    authorize! :manage, :finance
    
    @title = "Completed Events Validation"
    @events = Event.includes(:eventdates, :invoices).where(["events.status IN (?)", Event::Event_Status_Event_Completed]).order("representative_date DESC").paginate(:per_page => 50, :page => params[:page])
  end

  private
    def account_params
      params.require(:account).permit(:name, :is_credit, :position)
    end
end
