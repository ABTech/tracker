class JournalController < ApplicationController
  layout "finance"

  before_filter :authenticate_member!

  def list
    @title = "List of Journals"
    @journals = Journal.order("date DESC").paginate(:per_page => 50, :page => params[:date])
  end

  def view
    @title = "Viewing JE"
    @mode = Mode_View

    @journal = Journal.find(params['id'])
  end

  def new
    @title = "New JE"
    
    @journal = Journal.new()
    @journal.date = DateTime.now()
    @start = (Time.parse Account::Magic_Date)-1.year
    @end = (Time.parse Account::Future_Magic_Date)
    @events = Event.where(["representative_date >= ?", Account::Magic_Date]).order("title ASC")
    @event_id = params[:event_id] if params[:event_id]

    render(:action => "new")
  end

  def edit
    @title = "Editing JE"
    @mode = Mode_Edit
    @events = Event.where(["representative_date >= ?", Account::Magic_Date]).order("title ASC")
    @journal = Journal.find(params['id'])
    if(@journal.date>(Time.parse Account::Magic_Date) and @journal.date < (Time.parse Account::Future_Magic_Date))
      @start = (Time.parse Account::Magic_Date)-1.year
      @end = (Time.parse Account::Future_Magic_Date)
    end
  end

  def destroy
    @journal = Journal.find(params['id'])
    @journal.destroy

    flash[:notice] = "Successfully deleted #{@journal.memo} journal entry"
    redirect_to(:controller => "accounts", :action => "list")
  end

  def save
    errors = ""
    successfully_saved = 0
    
    num_times = params["njournals"] ? params["njournals"].to_i : 1
    num_times.times do |i|
      key = params["njournals"] ? ("journal" + i.to_s()) : "journal"
      if(params[key]["id"] && ("" != params[key]["id"]))
        journal = Journal.update(params[key]["id"], params[key])
      else
        journal = Journal.new(params[key])
        if (journal.memo == "" || journal.amount == 0)
          journal = nil
        end
      end
      
      if (journal && journal.valid? && journal.save())
        successfully_saved += 1
      elsif (journal)
        journal.errors.each_full() do |err|
          errors += err + "<br />"
        end
      end
      if params[:attachments] and params[:attachments][i.to_s] and !journal.nil?
        Attachment.create(:attachment => params[:attachments][i.to_s], :journal_id => journal.id)
      end
    end

    flash[:error] = errors unless errors.empty?
    flash[:notice] = successfully_saved.to_s + " Journal(s) Saved"
    
    if params[:event_id]
      redirect_to event_url(params[:event_id])
    else
      redirect_to(:controller => "accounts", :action => "list")
    end
  end
end
