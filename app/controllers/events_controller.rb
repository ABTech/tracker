class EventsController < ApplicationController
  skip_before_filter :authenticate_member!, :only => [:generate, :calendar, :callfeed, :index, :month]

  ### generate formats (for calendar view)
  Format_ScheduleFile = "schedule";
  Format_ICS          = "ics";
  Generate_Formats = [Format_ScheduleFile, Format_ICS];

  # currently, the range can't span years (ie, November -> January)
  Generate_Periods = {        # start        end
                    "f" => ['August 10 ', 'December 31 '],
                    "s" => ['January 1 ', 'May 31 '     ],
                    "u" => ['June 1 ',    'August 9 '   ]
                     };

  helper :members

  def show
    @title = "Viewing Event"
    @event = Event.find(params[:id])
    authorize! :read, @event
  end
  
  def show_email
    @title = "Viewing Event Emails"
    @event = Event.find(params[:id])
    authorize! :read, @event
  end
  
  def finance
    @title = "Viewing Event Finances"
    @event = Event.find(params[:id])
    authorize! :read, Timecard
  end

  def new
    @title = "Create New Event"
    @event = Event.new
    authorize! :create, @event
  end
  
  def duplicate
    @old_event = Event.find(params[:id])
    @event = @old_event.amoeba_dup
    
    @title = "Duplicate Event #" + @event.id.to_s
    authorize! :create, @event
  end

  def edit
    @title = "Edit Event"
    @event = Event.find(params[:id])
    authorize! :update, @event
  end
  
  def create
    @title = "Create New Event"
    
    if cannot? :create, Organization
      params[:event].delete(:org_type)
      params[:event].delete(:org_new)
    end
    
    p = params.require(:event).permit(:title, :org_type, :organization_id, :org_new, :status, :billable, :textable, :rental,
      :publish, :contact_name, :contactemail, :contact_phone, :price_quote, :notes,
      :eventdates_attributes =>
        [:startdate, :description, :enddate, :calldate, :strikedate, :calltype, :striketype, :email_description,
        {:location_ids => []}, {:equipment_ids => []}, {:event_roles_attributes => [:role, :member_id]}],
      :event_roles_attributes => [:role, :member_id],
      :attachments_attributes => [:attachment, :name],
      :blackout_attributes => [:startdate, :enddate, :with_new_event])
    
    @event = Event.new(p)
    authorize! :create, @event
    
    if @event.save
      flash[:notice] = "Event created successfully!"
      redirect_to @event
    else
      render :new
    end
  end

  def update
    @title = "Edit Event"
    @event = Event.find(params[:id])
    authorize! :update, @event
    
    p = params.require(:event).permit(:title, :org_type, :organization_id, :org_new, :status, :billable, :textable, :rental,
      :publish, :contact_name, :contactemail, :contact_phone, :price_quote, :notes,
      :eventdates_attributes =>
        [:id, :_destroy, :startdate, :description, :enddate, :calldate, :strikedate, :calltype, :striketype,
        :email_description, {:location_ids => []}, {:equipment_ids => []},
        {:event_roles_attributes => [:id, :role, :member_id, :_destroy]}],
      :attachments_attributes => [:attachment, :name, :id, :_destroy],
      :event_roles_attributes => [:id, :role, :member_id, :_destroy],
      :invoices_attributes => [:status, :journal_invoice_attributes, :update_journal, :id],
      :blackout_attributes => [:startdate, :enddate, :id, :_destroy])
    
    if cannot? :create, Organization
      p.delete(:org_type)
      p.delete(:org_new)
    end
    
    if cannot? :manage, :finance
      p.delete(:invoice_attributes)
    end
    
    if cannot? :tic, @event
      p.delete(:title)
      p.delete(:org_type)
      p.delete(:organization_id)
      p.delete(:org_new)
      p.delete(:status)
      p.delete(:billable)
      p.delete(:textable)
      p.delete(:rental)
      p.delete(:publish)
      p.delete(:contact_name)
      p.delete(:contactemail)
      p.delete(:contact_phone)
      p.delete(:price_quote)
      p.delete(:blackout_attributes)
      
      # If you are not TIC for the event, with regards to run positions, you
      # can only delete yourself from a run position, assign a member who isn't
      # you to be one of your assistants, or modify a run position which is one
      # of your assistants
      assistants = @event.run_positions_for(current_member).flat_map(&:assistants)
      p[:event_roles_attributes].select! do |bleh,er|
        if er[:id]
          rer = EventRole.find(er[:id])
          if rer.member_id == current_member.id
            er[:_destroy] == '1'
          else
            assistants.include? er[:role] and assistants.include? rer.role
          end
        else
          er[:member_id] != current_member.id and assistants.include? er[:role]
        end
      end
      
      # If you are not TIC for the event, with regards to eventdates, you
      # can only edit and delete eventdates that you are the TIC of. You cannot
      # create a new eventdate. If you are not the TIC of an eventdate but are
      # a run position, you may only delete yourself from a run position, assign
      # a member who isn't you to be one of your assistants, or modify a run
      # position which is one of your assistants
      if p[:eventdates_attributes]
        p[:eventdates_attributes].each do |key,ed|
          if ed[:id]
            red = Eventdate.find(ed[:id])
            if red.tic.id != current_member.id
              p[:eventdates_attributes][key].delete(:_destroy)
              p[:eventdates_attributes][key].delete(:startdate)
              p[:eventdates_attributes][key].delete(:description)
              p[:eventdates_attributes][key].delete(:enddate)
              p[:eventdates_attributes][key].delete(:calldate)
              p[:eventdates_attributes][key].delete(:strikedate)
              p[:eventdates_attributes][key].delete(:calltype)
              p[:eventdates_attributes][key].delete(:striketype)
              p[:eventdates_attributes][key].delete(:location_ids)
              p[:eventdates_attributes][key].delete(:equipment_ids)
              p[:eventdates_attributes][key].delete(:email_description)
            
              assistants = red.run_positions_for(current_member).flat_map(&:assistants)
              p[:eventdates_attributes][key][:event_roles_attributes].select! do |_,er|
                if er[:id]
                  rer = EventRole.find(er[:id])
                  if rer.member_id == current_member.id
                    er[:_destroy] == '1'
                  else
                    assistants.include? er[:role] and assistants.include? rer.role
                  end
                else
                  er[:member_id] != current_member.id and assistants.include? er[:role]
                end
              end
            end
          else
            p[:eventdates_attributes].delete(key)
          end
        end
      end
    end
    
    if @event.update(p)
      flash[:notice] = "Event updated successfully!"
      redirect_to @event
    else
      render :edit
    end
  end

  def destroy
    @event = Event.find(params["id"])
    authorize! :destroy, @event
    
    flash[:notice] = "Deleted event " + @event.title + "."
    @event.destroy()

    redirect_to(:action => "index")
  end

  def delete_conf
    @title = "Delete Event Confirmation"
    @event = Event.find(params["id"])
    authorize! :destroy, @event
  end

  def index
    @title = "Event List"
    authorize! :index, Event

    if(can? :read, Event)
      @eventdates = Eventdate.where("enddate >= ? AND NOT events.status IN (?)", Time.now.utc, Event::Event_Status_Group_Completed).order("startdate ASC").includes(:event).references(:event)
    else
      @eventdates = Eventdate.where("enddate >= ? AND NOT events.status IN (?) AND events.publish = true", Time.now.utc, Event::Event_Status_Group_Completed).order("startdate ASC").includes(:event).references(:event)
    end

    if not member_signed_in?
      render(:action => "index", :layout => "public")
    end
  end
  
  def month
    @title = "Event List for " + Date::MONTHNAMES[params[:month].to_i] + " " + params[:year]
    authorize! :index, Event
    if((Time.now.year > params[:year].to_i or Time.now.month > params[:month].to_i) and not can? :read, Event)
      redirect_to new_member_session_path and return
    end
    
    @startdate = Time.zone.parse(params["year"] + "-" + params["month"] + "-1").to_datetime.beginning_of_month
    enddate = @startdate.end_of_month

    if(can? :read, Event)
      @eventdates = Eventdate.where("enddate >= ? AND startdate <= ?", @startdate.utc, enddate.utc).order("startdate ASC")
    else
      @eventdates = Eventdate.where("enddate >= ? AND startdate <= ? AND events.publish = true", @startdate.utc, enddate.utc).order("startdate ASC").includes(:event).references(:event)
    end

    if not member_signed_in?
      render(:action => "month", :layout => "public")
    end
  end
  
  def incomplete
    @title = "Incomplete Event List"
    authorize! :read, Event
    
    @eventdates = Eventdate.where("NOT events.status IN (?)", Event::Event_Status_Group_Completed).order("startdate ASC").includes(:event).references(:event)
  end
  
  def past
    @title = "Past Event List"
    authorize! :read, Event
    
    @eventdates = Eventdate.where("startdate <= ?", Time.now.utc).order("startdate DESC").paginate(:per_page => 50, :page => params[:page])
  end
  
  def search
    @title = "Event List - Search for " + params[:q]
    authorize! :read, Event
    
    @eventdates = Eventdate.search (Riddle::Query.escape(params[:q])), :page => params[:page], :per_page => 50, :order => "startdate DESC"
  end

  def iphone
    authorize! :read, Event
    
    @startdate = params["startdate"] ? Date.parse(params["startdate"]) : Date.today 
    @enddate   = @startdate+7

    @eventdates = Eventdate.find(:all, :order => "startdate ASC", :conditions => ["? <= startdate AND ? > enddate", @startdate, @enddate])

    unless params[:showall]
      @eventdates.reject! do |eventdate|
        eventdate.event.publish == false
      end
    end

    unless @eventdates.empty?
      i = 0
      while (@eventdates[i] and @eventdates[i+1])
        if @eventdates[i].startdate.wday != @eventdates[i+1].startdate.wday
          #insert tombstome for new day
          @eventdates.insert(i+1, Date.parse(@eventdates[i+1].startdate.strftime("%F")))
          #skip tombstone
          i+=1
        end
        i += 1
      end
      @eventdates.insert(0, Date.parse(@eventdates[0].startdate.strftime("%F")))
    end
    render :layout => "iphone"
  end

  def calendar
    @title = "Calendar"
    
    if params[:selected]
      @selected = Time.zone.parse(params[:selected])
    else
      @selected = Time.zone.now
    end
    
    @selected_month = []
    12.times do |i|
      @selected_month[i] = @selected + (i-3).months
    end

    if not member_signed_in?
      render(:action => "calendar", :layout => "public")
    end
  end

  # Some documentation for generate (accessed with url /calendar/generate.(ics|calendar)
  # URL Parameters: [startdate (parsed date string), enddate, | matchdate] [showall (true|false),] [period (like f05 s01 u09 or fa05 sp02 su09 or soon)]
  # All parameters are optional. Default behavior is to give today's events.
  def generate
    # Determine date period
    if(params['startdate'] && params['enddate'])
      # use those dates as ranges
      begin
        @startdate = Date.parse(params['startdate']);
      rescue
        flash[:error] = "Start date format not valid.";
        index();
        render :action => 'index'
        return;
      end

      begin
        @enddate = Date.parse(params['enddate']);
      rescue
        flash[:error] = "End date format not valid.";
        index();
        render :action => 'index'
        return;
      end

    elsif(params['period'] &&
        ((params['period'].length() == 3) ||
         (params['period'].length() == 5)) )
      # a string such as 'f05' or 's01' or 'u09' [summer]
      period = params['period'].downcase();
      year   = period.slice(1..period.length());

      # if it's a two-digit year, expand
      if(year.length() == 2)
        year = "20" + year;
      end

      # find a relevant period, first
      range = Generate_Periods[period.slice(0..0)];
      if(!range)
        flash[:error] = "Invalid period prefix #{period.slice(0..0)}.";
        index();
        render :action => 'index'
        return;
      end

      @startdate = Date.parse(range.first + year);
      @enddate   = Date.parse(range.last  + year);
    elsif params['period'] == 'soon'
      #soon period is from 1 week ago through 3 weeks from now.
      #this is good for syncing a calendar
      @startdate = 1.week.ago
      @enddate = 3.months.from_now
    elsif params['matchdate']
      @startdate = Date.parse(params['matchdate'])
      @enddate = @startdate + 3.months
    else
      #assume the period is the current one if parsing the params has failed
      year = DateTime.now().year().to_s();
      matchdate = DateTime.now();
      if(params['matchdate'])
        begin
          matchdate = Date.parse(params['matchdate']);
        rescue
        end
      end

      @startdate = nil;

      Generate_Periods.keys.each do |period|
        range = Generate_Periods[period];
        rangestart = Date.parse(range.first + year);
        rangeend   = Date.parse(range.last  + year);

        if((rangestart.ajd() < matchdate.ajd()) &&
           (matchdate.ajd()  < rangeend.ajd()) )
          @startdate = rangestart;
          @enddate   = rangeend;
        end
      end

      if(!@startdate)
        flash[:error] = "No period matching today's date.";
        index();
        render :action => 'index'
        return;
      end
    end

    # find the eventdates relevant
    # showall=true param includes events that are unpublished (events.published == false)
    @eventdates = Eventdate.where("('#{@startdate.strftime("%Y-%m-%d")}' < startdate) AND ('#{@enddate.strftime("%Y-%m-%d")}' > enddate)").order(startdate: :asc).includes(:event, :locations)
    if not params[:showall]
      @eventdates = @eventdates.where("events.publish = TRUE").references(:events)
    end

    format = params['format'];
    if(!format || (format == ""))
      format = Format_ScheduleFile;
    end

    # flash[:notice] = "startdate: #{@startdate.to_s()}\nenddate: #{enddate.to_s()}";

    case(format)
    when Format_ScheduleFile
      render(:action => "generateschedule", :layout => false, :content_type => "text/plain");
    when Format_ICS
      render(:action => "generateics", :layout => false, :content_type => "text/calendar");
    else
      flash[:error] = "Please select a valid format.";
      redirect_to(:action => "index");
      return;
    end
  end
  
  def callfeed
    @calls = Eventdate.where("events.textable = TRUE").where("(calldate < ?) AND (calldate > ?)", 30.minutes.from_now, 2.hours.ago).includes(:event).references(:event)
    
    respond_to do |format|
      format.rss { render :layout => false }
    end
  end
end
