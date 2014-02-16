module EventsHelper
  def my_comment?(member)   
    member==current_member
  end
  
  def organizations_for_select
    Organization.active.order("name ASC").all.to_a.map do |org|
      [org.name, org.id]
    end
  end
  
  def statuses_for_select
    Event::Event_Status_Group_All.map do |status|
      [status, status]
    end
  end
  
  def roles_for_select
    ([""] | EventRole::Roles_All).map do |role|
      [role, role]
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
end
