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
  
  def eventslist(eventdates)
    # The following code establishes "runs" of eventdates with the same event
    # because we want such runs to share a roles field instead of displaying
    # the same, potentially large, roles field multiple times.
    eventdates = eventdates.to_a
    eventruns = [0]
    er = eventdates.reverse
    er.each_with_index do |ed,i|
      if i > 0
        if er[i-1].event == ed.event and er[i-1].event_roles.empty? and ed.event_roles.empty?
          eventruns[i] = eventruns[i-1] + 1
        else
          eventruns[i] = 0
        end
      end
    end
    eventruns.reverse!
    eventdates.map!.with_index do |ed,i|
      if eventruns[i] > 0
        if i == 0 or eventruns[i-1] == 0
          { :eventdate => ed, :roles => :show, :run => eventruns[i] + 1 }
        else
          { :eventdate => ed, :roles => :hide, :run => 1 }
        end
      else
        if i > 0 and eventruns[i-1] > 0
          { :eventdate => ed, :roles => :hide, :run => 1 }
        else
          { :eventdate => ed, :roles => :show, :run => 1 }
        end
      end
    end
    
    render :partial => "events/list", :locals => { :eventdates => eventdates }
  end
  
  def organizations_for_select
    Organization.active.order("name ASC").all.to_a.map do |org|
      [org.name, org.id]
    end
  end
  
  def members_for_select(role)
    members = [["unassigned", [["unassigned", ""]]]]
    members << ["Active Members", Member.active.order("namefirst ASC, namelast ASC").map {|m| [m.fullname, m.id]}]
    members << ["Alumni", Member.where(role: "alumni").order("namefirst ASC, namelast ASC").map {|m| [m.fullname, m.id]}]
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
  
  def link_to_add_blackout(f)
    new_object = Blackout.new
    fields = f.fields_for(:blackout, new_object, :child_index => "new_blackout") do |builder|
      render("events/blackout_fields", :f => builder)
    end
    link_to("Create blackout period", "#", class:"add_blackout_fields", data: {content: "#{fields}"}, onClick: "return false")
  end
  
  def link_to_remove_blackout(f)
    f.hidden_field(:_destroy) + link_to("Remove blackout period?", "#", class: "delete_blackout_fields", onClick: "return false")
  end

  def link_to_add_eqev_fields(name, f, association, event, controller="")
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(controller + "/" + association.to_s.singularize + "_fields", :f => builder, :e => event)
    end
    link_to(name, "#", class:"add_field", data: {association: "#{association}", content: "#{fields}"}, onClick: "return false")
  end
end
