class JournalsController < ApplicationController
  layout "finance"

  def list
    authorize! :read, Journal
    
    @title = "List of Journals"
    @journals = Journal.order("date DESC").accessible_by(current_ability).paginate(:per_page => 50, :page => params[:date])
  end

  def view
    @title = "Viewing JE"
    @mode = Mode_View

    @journal = Journal.find(params['id'])
    authorize! :read, @journal
  end

  def new
    @title = "New JE"
    
    @journal = Journal.new()
    @journal.date = DateTime.now()
    authorize! :create, @journal
    
    @start = (Time.parse Account.magic_date)-1.year
    @end = (Time.parse Account.future_magic_date)
    @events = Event.where(["representative_date >= ?", Account.magic_date]).order("title ASC")
    @event_id = params[:event_id] if params[:event_id]

    render(:action => "new")
  end

  def edit
    @title = "Editing JE"
    @mode = Mode_Edit
    @events = Event.where(["representative_date >= ?", Account.magic_date]).order("title ASC")
    @journal = Journal.find(params['id'])
    authorize! :update, @journal
    
    if(@journal.date>(Time.parse Account.magic_date) and @journal.date < (Time.parse Account.future_magic_date))
      @start = (Time.parse Account.magic_date)-1.year
      @end = (Time.parse Account.future_magic_date)
    end
  end

  def destroy
    @journal = Journal.find(params['id'])
    authorize! :destroy, @journal
    
    @journal.destroy

    flash[:notice] = "Successfully deleted #{@journal.memo} journal entry"
    redirect_to(:controller => "accounts", :action => "list")
  end

  def save
    errors = ""
    successfully_saved = 0
    params.permit!
    
    num_times = params["njournals"] ? params["njournals"].to_i : 1
    num_times.times do |i|
      key = params["njournals"] ? ("journal" + i.to_s()) : "journal"
      if(params[key]["id"] && ("" != params[key]["id"]))
        journal = Journal.update(params[key]["id"], params[key])
        authorize! :update, journal
      else
        journal = Journal.new(params[key])
        authorize! :create, journal
        
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
