class EventsController < ApplicationController
  #TODO: what is this file? What does it do?
  #require 'rmail.rb'
  before_filter :login_required, :except => [:generate, :calendar];

  ### various parameters for editing things
  # number of empty date rows to show for new and old events
  New_Event_New_Date_Display_Count = 3;
  Old_Event_New_Date_Display_Count = 3;
  # number of empty role rows to show for new and old events
  New_Event_New_Role_Display_Count = 5;
  Old_Event_New_Role_Display_Count = 3;
  # number of empty log to show for events
  ### flags for organization new/old on event save
  New_Event_Existing_Organization = "existing";
  New_Event_New_Organization      = "new";

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
    @mode = Mode_View;
    @title = "Viewing Event";

    @event = Event.find_by_id(params["id"], :include => [:eventdates, :emails, :organization]);
    @new_comment = @event.comments.build

    if(!@event)
      flash[:error] = "Event #{params['id']} not found. Did you enter that ID manually? If not, something is very wrong."
      redirect_to(:action => "index");
      return;
    end

    @event_page = "main";
    render(:action => "record");
  end

  def new
  @title = "Create New Event";
  @mode = Mode_New;
  @event = EventsHelper.generate_new_event();
  end

  def edit
    @title = "Edit Event";
    @mode = Mode_Edit;
    if(!@event)
      if(!params["id"])
        flash[:error] = "You must specify an ID.";
        redirect_to(:action=> "index");
        return;
      end

      @event = Event.find_by_id(params["id"]);
      if(!@event)
        flash[:error] = "Event #{params['id']} not found. Did you enter that ID manually? If not the tracker is f--k'd."
        redirect_to(:action => "index");
        return;
      end
    end

    if (params["page"] != "new")
      Old_Event_New_Date_Display_Count.times do
        dt = Eventdate.new()
        dt.calldate = Time.now();
        dt.startdate = Time.now();
        dt.enddate = Time.now();
        dt.strikedate = Time.now();
        @event.eventdates << dt;
      end
      Old_Event_New_Role_Display_Count.times do
        rl = EventRole.new();
        @event.event_roles << rl;
      end
    end

    @event_page = "main";
    render(:action => "record");
  end

  def create
    # --------------------
    # create new event/find old event
    if(params["event"]["id"] && (params["event"]["id"] != ""))
      save_event = Event.update(params["event"]["id"], params['event']);
    else
      save_event = Event.new(params['event']);
      save_event.year_id = Year.active_year.id;
    end

    nots, errs = EventsHelper.update_event(save_event, params)
    flash[:notice] = nots;
    flash[:error] = errs;

    # Add attachment if necessary
    if params[:attachments]
      Attachment.create(:attachment => params[:attachments]["1"], :event_id => save_event.id)
    end

    # -------------------
    # sort event.event_roles for viewing pleasure
    save_event.event_roles.sort!
    # --------------------
    # save event
    if(save_event.save())
      flash[:notice] += "<br/>Event Saved";
    else
      save_event.errors.each_full() do |err|
        flash[:error] += err + "<br />";
      end
    end

    if(params["redirect"])
      redirect_to(params["redirect"])
    elsif(save_event.new_record?())
      redirect_to(:action => "new");
    else
      redirect_to(:action => "edit", :id => save_event.id);
    end
  end #end of update

  def delete
    if(!@event)
      if(!params["id"])
        flash[:error] = "You must specify an ID.";
        redirect_to(:action=> "index");
        return;
      end

      @event = Event.find(params["id"]);
      if(!@event)
        flash[:error] = "Event #{params['id']} not found."
        redirect_to(:action => "index");
        return;
      end
    end

    flash[:notice] = "Deleted event " + @event.title + ".";
    @event.destroy();

    redirect_to(:action => "index");
  end

  def delete_conf
    @title = "Delete Event Confirmation";

    if(!@event)
      if(!params["id"])
        flash[:error] = "You must specify an ID.";
        redirect_to(:action=> "index");
        return;
      end

      @event = Event.find(params["id"]);
      if(!@event)
        flash[:error] = "Event #{params['id']} not found."
        redirect_to(:action => "index");
        return;
      end
    end
  end

  helper_method :filtered_events;
  def filtered_events(options = {})
    default_options = {
      :search_terms => nil,
      :startdate => nil, # Time or DateTime
      :enddate => nil, # Time or DateTime
      :order => "eventdates.startdate ASC",
      :condquery => "TRUE",
      :condargs => [],
      :limit => nil # nil = no limit
    }

    options = default_options.merge(options);

    if (options[:startdate] && (options[:startdate].class == DateTime || options[:startdate].class == Date))
      options[:startdate] = Time.parse(options[:startdate].strftime("%c"));
    end
    if(options[:enddate] && (options[:enddate].class == DateTime || options[:enddate].class == Date))
      options[:enddate] = Time.parse(options[:enddate].strftime("%c"));
    end

    order = options[:order];
    joins = "";
    limit = options[:limit];

    condquery = options[:condquery];
    condargs = options[:condargs];

    # here's where we handle searches
    if(options[:search_terms])
      options[:search_terms].split().each do |word|
        condquery += " AND (events.title LIKE (?))";
        condquery += " OR (eventdates.description LIKE (?))";
        condargs << "%" + word + "%";
        condargs << "%" + word + "%";
      end
    end

    if(options[:startdate])
      condquery += " AND (UNIX_TIMESTAMP(eventdates.enddate) > (?))";
      condargs << options[:startdate].to_i();
    end

    if(options[:enddate])
      condquery += " AND (UNIX_TIMESTAMP(eventdates.startdate) < (?))";
      condargs << options[:enddate].to_i();
    end

    if limit != nil
      count = Eventdate.count(:all,
                             :include => [:event],
                             :joins => joins,
                             :conditions => [condquery] + condargs,
                             :order => order)
      page = params[:page].to_i
      page = 1 if page < 1 or (page-1)*limit + 1 > count
      pages = { :count => count,
                :page => page,
                :first => (page-1)*limit + 1,
                :last => (page*limit > count) ? count : page*limit,
                :page_count => (count/limit.to_f).ceil }
      pages[:next] = page + 1 if page*limit < count
      pages[:prev] = page - 1 if page > 1
      eventdates = Eventdate.find(:all,
        :include => [:event],
        :joins => joins,
        :conditions => [condquery] + condargs,
        :order => order,
        :limit => limit,
        :offset => (page-1)*limit)
        
      return pages, eventdates
    else
      eventdates = Eventdate.find(:all,
        :include => [:event],
        :joins => joins,
        :conditions => [condquery] + condargs,
        :order => order)
      return nil, eventdates
    end
  end

  def index
    @title = "Event List";

    # default view mode
    if (not params["selected"])
      params["selected"] = "future";
    end

    # set up options
    options = {:limit => 50};
    if (params[:selected] == "future")
      options[:startdate] = Time.now;
    elsif (params[:selected] == "past")
      options[:enddate] = Time.now;
      options[:order] = "eventdates.startdate DESC";
    elsif (params[:selected] == "incomplete")
      options[:condquery] = "NOT events.status IN (?)";
      options[:condargs] = [Event::Event_Status_Group_Completed];
    elsif (params[:selected] == "month")
      options[:startdate] = Date.civil(params["year"].to_i, params["month"].to_i, 1)
      options[:enddate] = options[:startdate] >> 1;
    elsif (params[:selected] == "search")
      options[:search_terms] = params["q"];
      options[:order] = "eventdates.startdate DESC";
    end

    # grab the events for the list
    @event_pages, @eventdates = filtered_events(options);

    # grab the events for the calendar
    if params["selected"] == "month"
      @monthdates = Array.new(@eventdates)
    elsif @eventdates.empty?
      firstOfThisMonth = Date.civil(Date.today.year, Date.today.month, 1)
      _, @monthdates = filtered_events({:startdate => firstOfThisMonth, :enddate => (firstOfThisMonth >> 1)})
    else
      firstOfFirstEventsMonth = Date.civil(@eventdates[0].startdate.year, @eventdates[0].startdate.month, 1)
      _, @monthdates = filtered_events({:startdate => firstOfFirstEventsMonth, :enddate => (firstOfFirstEventsMonth >> 1)})
    end

    render(:layout => "application2")
  end

  def calendar_full
    # this exists only to check permissions on the action, so don't merge into calendar
    calendar();
    render :action => 'calendar'
  end

  def iphone
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

  def mobile
    @selected = DateTime.now();

    weekStart = @selected - (@selected.cwday() - 1);
    weekEnd   = weekStart + 7;
    @eventdates_week, count = filtered_events({:startdate => weekStart, :enddate => weekEnd, :custom_condition => "(events.publish OR events.blackout)"});

    @title = "Mobile View";

    render(:action => "mobile_calendar", :layout => "mobile");
  end

  def mobile_email
    @title = "Mobile Email View";

    @event = Event.find(params['id'], :include => [:eventdates, :emails, :organization]);

    render(:action => "mobile_email", :layout => "mobile");
  end

  def calendar
    ### also handles full_calendar and public calendar
    @title = "Calendar";

    if(!current_member || !current_member.authorized?("/#{controller_name()}/#{action_name()}"))
      @public = true;
    else
      @public = false;
    end

    if(params["selected"])
      @selected = DateTime.parse(params["selected"]);
    else
			@selected = DateTime.new(Time.now.year, Time.now.month, Time.now.day)
		end

    filterStr = "(events.publish OR events.blackout)";
    if(action_name() == "calendar_full")
      filterStr = "(events.publish OR events.blackout OR (events.status IN ('#{Event::Event_Status_Group_Not_Cancelled.join("','")}')))";
    end

    @selected_month = [];
    @eventdates_month = [];
    12.times do |i|
    month = @selected >> (i-3);
      @selected_month[i] = @selected >> (i-3);
      monthStart = month - (month.day-1);
      monthEnd   = monthStart >> 1;
      _, @eventdates_month[i] = filtered_events({:startdate => monthStart, :enddate => monthEnd, :custom_condition => filterStr});
      if @eventdates_month[i] == nil
        asdasdas # wtf???
      end
    end

    weekStart = @selected - (@selected.cwday() - 1);
    weekEnd   = weekStart + 7;
    _, @eventdates_week = filtered_events({:startdate => weekStart, :enddate => weekEnd, :custom_condition => filterStr});

    if(@public)
      render(:action => "calendar", :layout => "public");
    else
      render(:layout => "application2")
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
    if(params['showall'])
      @eventdates = Eventdate.find(:all,
                                   :conditions => "('#{@startdate.strftime("%Y-%m-%d")}' < startdate) AND " +
                                                  "('#{@enddate.strftime("%Y-%m-%d")}' > enddate)",
                                   :order => "startdate ASC",
                                   :include => [:event, :locations]);
    else
      @eventdates = Eventdate.find(:all, 
                                   :conditions => "('#{@startdate.strftime("%Y-%m-%d")}' < startdate) AND " +
                                                    "('#{@enddate.strftime("%Y-%m-%d")}' > enddate) AND " +
                                                    "(events.publish)",
                                   :order => "startdate ASC",
                                   :include => [:event, :locations]);
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

  def lost
    @events = Event.find(:all, :order => 'updated_on desc').select { |e| e.eventdates.empty? }
    render :layout => "application2"
  end

  private
  # special authentication method which does the standard
  # "are you authorized" check, but also checks to see if the user
  # has a role related to the current event. if so, the user is
  # allowed access such that a TIC (or someone else having an
  # event runcrew position) may be allowed access to their own
  # event.
  def login_or_role_required
    if(logged_in?)
      searchID = params["event"] ? params["event"]["id"] : params["id"];
      perms = EventRole.find(:all,
                             :conditions => ["member_id = (?) AND event_id = (?)", 
                                             current_member().id, 
                                             searchID]);
      if(!perms.empty?)
        return true;
      end
    end

    return login_required();
  end
end
