class EventsController < ApplicationController
  skip_before_action :authenticate_member!, :only => [:generate, :calendar, :index, :month, :eventrequest, :reference]
  skip_before_action :verify_authenticity_token, :only => [:eventrequest]

  helper :members
  helper_method :event_request_notes

  def show
    @title = "Viewing Event"
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
    @event.status = Event::Event_Status_Initial_Request
    
    @title = "Duplicate Event #" + @event.id.to_s
    authorize! :create, @event
  end

  def edit
    @title = "Edit Event"
    @event = Event.find(params[:id])
    
    @event.eventdates.each do |ed|
      ed.event_roles.build if ed.event_roles.empty?
    end
    
    authorize! :update, @event
  end

  # This method used for request form on abtech.org
  def eventrequest
    @title = "Request New Event"
    
    input = params.require([:event_name, :organization, :contact_name,
                            :contact_email, :contact_phone, :start_date,
                            :start_time, :end_date, :end_time, :location,
                            :details])

    startdate = Time.zone.parse(params[:start_date] + " " + params[:start_time]).to_datetime
    enddate = Time.zone.parse(params[:end_date] + " " + params[:end_time]).to_datetime

    requestdate = DateTime.now
    minDate = requestdate - 2.years

    if params.has_key?(:includes)
      includes = params[:includes]
    else
      includes = []
    end

    notes = event_request_notes(params[:event_name], params[:organization],
                                params[:oracle_string], params[:contact_name],
                                params[:contact_email], params[:contact_phone],
                                startdate, enddate, requestdate,
                                params[:location], includes, params[:details])

    p = ActionController::Parameters.new({
      event: {
        title: params[:event_name],
        organization_id: 0,
        status: Event::Event_Status_Initial_Request,
        billable: 1,
        rental: 0,
        textable: 0,
        publish: 0,
        contact_name: params[:contact_name],
        contactemail: params[:contact_email],
        contact_phone: params[:contact_phone],
        notes: "Requested via event request form. Please preserve this request text when editing this event:\n\n" + notes,
        eventdates_attributes: [{
          startdate: startdate,
          description: "Request",
          enddate: enddate,
          email_description: "",
          notes: "",
          location_ids: [0]
        }]
      }
    })
    p = p.require(:event).permit(:title, :organization_id, :status, :billable,
                                 :rental, :textable, :publish, :contact_name,
                                  :contactemail, :contact_phone, :notes,
                                  :eventdates_attributes =>
                                    [:startdate, :description, :enddate,
                                     :email_description, :notes,
                                     {:location_ids => []}])

    @event = Event.new(p)
    if startdate < minDate or enddate < minDate
      form_error = ["Event takes place in the past! Please double check your requested dates."]
      render json: form_error, status: 400
    elsif startdate.minute % 5 != 0 or enddate.minute % 5 != 0
      form_error = ["Event times must be on five minute intervals. Please double check your requested times."]
      render json: form_error, status: 400
    else
      if @event.save
        begin
          request_email = EventRequestMailer.event_request(@event, notes).deliver_now
          EventRequestMailer.event_created(@event, request_email.message_id).deliver_now
        rescue
          @event.notes += "\n\nNOTE: FAILED TO SEND CONFIRMATION AND/OR LINK EMAIL!"
          @event.save
          head 500
        else
          head 200
        end
      else
        form_error = @event.errors.full_messages
        render json: form_error, status: 400
      end
    end
  end
  
  def create
    @title = "Create New Event"
    
    if cannot? :create, Organization
      params[:event].delete(:org_type)
      params[:event].delete(:org_new)
    end
    
    p = params.require(:event).permit(:title, :org_type, :organization_id, :org_new, :status, :billable, :rental,
      :textable, :publish, :contact_name, :contactemail, :contact_phone, :price_quote, :notes, :created_email,
      :eventdates_attributes =>
        [:startdate, :description, :enddate, :calldate, :strikedate, :calltype, :striketype, :email_description, :notes,
        :billable_call, :billable_show, :billable_strike,
        {:location_ids => []}, {:equipment_ids => []}, {:event_roles_attributes => [:role, :member_id, :appliable]}],
      :event_roles_attributes => [:role, :member_id, :appliable],
      :attachments_attributes => [:attachment, :name],
      :blackout_attributes => [:startdate, :enddate, :with_new_event, :_destroy])
    
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
    
    p = params.require(:event).permit(:title, :org_type, :organization_id, :org_new, :status, :billable, :rental,
      :textable, :publish, :contact_name, :contactemail, :contact_phone, :price_quote, :notes,
      :eventdates_attributes =>
        [:id, :_destroy, :startdate, :description, :enddate, :calldate, :strikedate, :calltype, :striketype,
        :billable_call, :billable_show, :billable_strike,
        :email_description, :notes, {:location_ids => []}, {:equipment_ids => []},
        {:event_roles_attributes => [:id, :role, :member_id, :appliable, :_destroy]}],
      :attachments_attributes => [:attachment, :name, :id, :_destroy],
      :event_roles_attributes => [:id, :role, :member_id, :appliable, :_destroy],
      :invoices_attributes => [:status, :id],
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
      
      # If you are not TiC for the event, with regards to run positions, you
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
      
      # If you are not TiC for the event, with regards to eventdates, you
      # can only edit and delete eventdates that you are the TiC of. You cannot
      # create a new eventdate. If you are not the TiC of an eventdate but are
      # a run position, you may only delete yourself from a run position, assign
      # a member who isn't you to be one of your assistants, or modify a run
      # position which is one of your assistants
      if p[:eventdates_attributes]
        p[:eventdates_attributes].each do |key,ed|
          if ed[:id]
            red = Eventdate.find(ed[:id])
            if !red.tic.include? current_member
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
              p[:eventdates_attributes][key].delete(:billable_call)
              p[:eventdates_attributes][key].delete(:billable_show)
              p[:eventdates_attributes][key].delete(:billable_strike)
            
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
    @event.destroy

    redirect_to events_url
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
      @eventdates = Eventdate.where("enddate >= ? AND NOT events.status IN (?)", Time.now.utc, Event::Event_Status_Group_Completed)
    else
      @eventdates = Eventdate.where("enddate >= ? AND NOT events.status IN (?) AND events.publish = true", Time.now.utc, Event::Event_Status_Group_Completed).order("startdate ASC")
    end
    
    @eventdates = @eventdates.order("startdate ASC").includes({event: [:organization]}, {event_roles: [:member]}, :locations, :equipment).references(:event)
    @eventweeks = Eventdate.weekify(@eventdates)

    if not member_signed_in?
      render(:action => "index", :layout => "public")
    end
  end
  
  def month
    @title = "Event List for " + Date::MONTHNAMES[params[:month].to_i] + " " + params[:year]
    authorize! :index, Event
    if((Time.now.year > params[:year].to_i or (Time.now.year == params[:year].to_i and Time.now.month > params[:month].to_i)) and not can? :read, Event)
      redirect_to new_member_session_path and return
    end
    
    @startdate = Time.zone.parse(params["year"] + "-" + params["month"] + "-1").to_datetime.beginning_of_month
    enddate = @startdate.end_of_month

    if(can? :read, Event)
      @eventdates = Eventdate.where("enddate >= ? AND startdate <= ?", @startdate.utc, enddate.utc).order("startdate ASC")
    else
      @eventdates = Eventdate.where("enddate >= ? AND startdate <= ? AND events.publish = true", @startdate.utc, enddate.utc).order("startdate ASC").includes(:event).references(:event)
    end
    
    @eventruns = Eventdate.runify(@eventdates)

    if not member_signed_in?
      render(:action => "month", :layout => "public")
    end
  end
  
  def incomplete
    @title = "Incomplete Event List"
    authorize! :read, Event
    
    @eventdates = Eventdate.where("NOT events.status IN (?)", Event::Event_Status_Group_Completed).order("startdate ASC").includes(:event).references(:event)
    @eventruns = Eventdate.runify(@eventdates)
  end
  
  def past
    @title = "Past Event List"
    authorize! :read, Event
    
    @eventdates = Eventdate.where("startdate <= ?", Time.now.utc).order("startdate DESC").paginate(:per_page => 50, :page => params[:page])
    @eventruns = Eventdate.runify(@eventdates)
  end
  
  def search
    @title = "Event List - Search for " + params[:q]
    authorize! :read, Event
    
    @eventdates = Eventdate.search params[:q].gsub(/[^A-Za-z0-9 ]/,""), :page => params[:page], :per_page => 50, :order => "startdate DESC"
    @eventruns = Eventdate.runify(@eventdates)
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

  def reference
    @title = "Reference"
  end

  # Some documentation for generate (accessed with url /calendar/generate.(ics|calendar)
  # URL Parameters: [startdate (parsed date string), enddate, | matchdate] [showall (true|false),] [period (like f05 s01 u09 or fa05 sp02 su09 or soon)]
  # All parameters are optional. Default behavior is to give today's events.
  def generate
    # Determine date period
    if params[:startdate] and params[:enddate]
      begin
        @startdate = Date.parse(params['startdate'])
      rescue
        render text: "Start date is not valid." and return
      end

      begin
        @enddate = Date.parse(params['enddate'])
      rescue
        render text: "End date is not valid." and return
      end
    elsif params[:period] == "soon"
      # "Soon" is from 1 week ago through 3 months from now.
      # This is good for syncing a calendar.
      @startdate = 1.week.ago
      @enddate = 3.months.from_now
    elsif params[:period]
      # a string such as 'f2005' or 'S01' or 'u09' [summer]
      if not (params[:period].length == 3 or params[:period].length == 5)
        render text: "Badly formatted period." and return
      end
      
      year = params[:period][1..-1]
      if year.length == 2
        year = "20" + year
      end
      
      period = params[:period][0].downcase
      if period == "f"
        @startdate = Date.new(year.to_i, 8, 10)
        @enddate = Date.new(year.to_i, 12, 31)
      elsif period == "s"
        @startdate = Date.new(year.to_i, 1, 1)
        @enddate = Date.new(year.to_i, 5, 31)
      elsif period == "u"
        @startdate = Date.new(year.to_i, 6, 1)
        @enddate = Date.new(year.to_i, 8, 9)
      else
        render text: "Invalid period." and return
      end
    else
      # Assume the period is the current one if parsing the params has failed.
      reference = Date.today
      if params[:matchdate]
        begin
          reference = Date.parse(params[:matchdate])
        rescue
          render text: "Match date is not valid." and return
        end
      end
      
      year = reference.year
      
      case reference
      when Date.new(year, 8, 10)..Date.new(year, 12, 31)
        @startdate = Date.new(year, 8, 10)
        @enddate = Date.new(year, 12, 31)
      when Date.new(year, 1, 1)..Date.new(year, 5, 31)
        @startdate = Date.new(year, 1, 1)
        @enddate = Date.new(year, 5, 31)
      else
        @startdate = Date.new(year, 6, 1)
        @enddate = Date.new(year, 8, 9)
      end
    end

    @eventdates = Eventdate.where("(? < startdate) AND (? > enddate)", @startdate, @enddate).order(startdate: :asc).includes(:event, :locations)
    
    # showall=true param includes unpublished events
    if not params[:showall]
      @eventdates = @eventdates.where("events.publish = TRUE").references(:events)
    end
    
    respond_to do |format|
      format.schedule
      format.ics
    end
  end

  private

    def event_request_notes(name, org, oracle_string, contact, email, phone, startdate, enddate, requestdate, location, includes, details)
      event_includes = ""
      event_includes += "CMU Media Services, " if includes.include?("cmu_media_services")
      event_includes += "cmuTV, " if includes.include?("cmutv")
      event_includes += "Outside Vendors, " if includes.include?("outside_av_vendors")
      event_includes += "Additional Staging, " if includes.include?("additional_staging")
      event_includes += "Zoom, " if includes.include?("zoom")
      event_includes += "Live Streaming, " if includes.include?("live_streaming")
      event_includes += "Recording, " if includes.include?("recording")
      event_includes += "Presentation Slides, " if includes.include?("presentation_slides")
      event_includes += "Video Playback, " if includes.include?("video_playback")
      event_includes += "Non-CMU Affiliates Performing, " if includes.include?("non_cmu_affiliates_performing")
      if event_includes.to_s.empty?
        event_includes = "None"
      else
        event_includes = event_includes[0...-2] unless event_includes.to_s.empty?
      end

      <<~EOF
      Event Name: #{name}
      Organization: #{org}
      Oracle String: #{oracle_string}
      Event Contact: #{contact}
      Email: #{email}
      Phone: #{phone}
      Request Date: #{requestdate.strftime("%m/%d/%Y at %l:%M %p")}
      Start Date: #{startdate.strftime("%m/%d/%Y at %l:%M %p")}
      End Date: #{enddate.strftime("%m/%d/%Y at %l:%M %p")}
      Location: #{location}
      Event Includes: #{event_includes}
      Details:
      #{details}
      EOF
    end
end
