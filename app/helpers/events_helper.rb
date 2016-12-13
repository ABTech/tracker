module EventsHelper
  def monthview(month, options={})
    firstOfMonth = month.beginning_of_month
    startDisplay = firstOfMonth.beginning_of_week
    endOfMonth = month.end_of_month
    endDisplay = endOfMonth.end_of_week
    startdate = options[:full_month] ? startDisplay : firstOfMonth
    enddate = options[:full_month] ? endDisplay : endOfMonth
    
    show_arrows = options[:show_arrows] || false
    published = options[:published] || false
    show_blackouts = options[:blackouts] || false
    
    eventdates = Eventdate.order("startdate ASC").where("startdate <= ? AND enddate >= ? AND events.status IN (?)", enddate.utc, startdate.utc, Event::Event_Status_Group_Not_Cancelled).includes(:event).references(:event)
    
    if show_blackouts
      blackouts = Blackout.where("startdate <= ? AND enddate >= ?", enddate.utc, startdate.utc)
    else
      blackouts = []
    end
    
    if published
      eventdates = eventdates.where("events.publish = TRUE")
    end
    
    # Ruby has difficulty with Time ranges so we have do use this kludge
    monthdates = []
    curdate = startDisplay
    while curdate <= endDisplay
      monthdates << curdate
      curdate += 1.day
    end

    monthdates.map! do |date|
      if date < startdate or date > enddate
        { :date => date, :included => false, :events => [] }
      else
        { :date => date,
          :included => true,
          :events => eventdates.select {|ed| date.end_of_day >= ed.startdate and date.beginning_of_day <= ed.enddate },
          :blackout => blackouts.find {|b| date.end_of_day >= b.startdate and date.beginning_of_day <= b.enddate }
        }
      end
    end
    
    render :partial => "events/monthview", :locals => {monthdates: monthdates, show_arrows: show_arrows, selected: month}
  end
  
  def organizations_for_select
    Organization.active.order("name ASC").to_a.map do |org|
      [org.name, org.id]
    end
  end
  
  def members_for_select(role)
    members = [["unassigned", [["unassigned", ""]]]]
    members << ["Active Members", Member.active.alphabetical.map {|m| [m.fullname, m.id]}]
    members << ["Alumni", Member.where(role: "alumni").alphabetical.map {|m| [m.fullname, m.id]}]
  end
  
  def month_links(cur=nil,count=nil)
    now = Time.now
    now_year = cur ? cur.year : now.year
    now_mon = cur ? cur.month : now.month
    if now_mon < 6
      now_year -= 1
    end
    months = Time::RFC2822_MONTH_NAME
    month_links = []
    indices = [(6..12).to_a, (1..5).to_a]
    indices.each do |is|
      is.map! do |i|
        if cur and cur.year == now_year and cur.month == i
          month_links << "<b>" + months[i-1] + " (" + count.to_s + ")" + "</b>"
        else
          month_links << link_to(months[i-1], month_events_url(now_year, i))
        end
      end
      now_year += 1
    end
    month_links.join(" | ").html_safe
  end
  
  def render_eventdate_call(ed)
    if ed.has_call?
      ed.effective_call.strftime("%H:%M")
    elsif ed.calltype == "blank"
      "<span class='unknown'>unknown</span>".html_safe
    end
  end
  
  def render_eventdate_strike(ed)
    if ed.has_strike?
      ed.effective_strike.strftime("%H:%M")
    elsif ed.striketype == "blank"
      "<span class='unknown'>unknown</span>".html_safe
    elsif ed.striketype == "none"
      "none"
    end
  end
  
  def eventdate_call_selected_value(eventdate)
    if eventdate.has_call?
      eventdate.effective_call
    else
      DateTime.now
    end
  end
  
  def eventdate_strike_selected_value(eventdate)
    if eventdate.has_strike?
      eventdate.effective_strike
    else
      DateTime.now
    end
  end
  
  def supertic_add_role(f, date)
    select_tag("", options_for_select(SuperTic.extant_days.collect do |day|
      new_object = EventRole.new(role: EventRole::Role_exec, member: day.member)
      fields = f.fields_for(:event_roles, new_object, :child_index => "new_event_roles") do |builder|
        render("events/event_role_fields", {:f => builder, :parent => f.object})
      end
      [day.dayname, day.day, data: {role: "#{fields}"}]
    end, date.nil? ? nil : date.to_date.cwday), class: "supertic_add_role_select") + button_tag("Add", type: :button, class: "supertic_add_role_button")
  end
  
  def show_run_position(er)
    if not er.assigned? and er.applications.where(member: current_member).count > 0
      "(applied!)"
    elsif not er.assigned? and can? :create, er.applications.build(member: current_member)
      link_to("you?", new_application_url(er.event, event_role_id: er.id, format: :js), :remote => true)
    else
      er.assigned_to
    end
  end
  
end
