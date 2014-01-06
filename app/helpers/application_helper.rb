module ApplicationHelper
  def ajax_link_to(text, options)
    return "<a href=\"javascript:doAndReload('" +
           url_for(options) +
           "')\">" +
           text +
           "</a>";
  end
  
  def conditional_link_to(title, controller, action)
    if (current_member().authorized?("%s/%s" % [controller, action]))
      link_to(title, {:controller => controller, :action => action})
    else
      ""
    end
  end

  def conditional_link_to_remote(title, controller, action, update, html = {})
    if (current_member().authorized?("%s/%s" % [controller, action]))
      link_to(title, { :url => {:controller => controller, :action => action}, :update => update }, html, :remote => true)
    else
      ""
    end
  end

  Date.class_eval do
    def ago
      return "today" if Date.today-self == 0 
      return "yesterday" if Date.today-self == 1
      return "tomorrow" if Date.today-self == -1
      return (Date.today-self).to_s+" days ago" if Date.today-self > 0
      return "in "+(self-Date.today).to_s+" days" if Date.today-self < 0
    end
  end

  def iphone_user_agent?
    controller.iphone_user_agent?
  end

  def app_version
    begin
      %x{git log --pretty=format:"%h"  -n1}
    rescue
      "?"
    end
  end
  
  def get_sidebar_monthdates
    startdate = DateTime.new(Time.now.year, Time.now.month, 1)
    enddate = DateTime.new(Time.now.year, Time.now.month, Time.days_in_month(Time.now.month))
    Eventdate.where(["UNIX_TIMESTAMP(enddate) > ? AND UNIX_TIMESTAMP(startdate) < ?", startdate.to_i, enddate.to_i]).order("startdate ASC").includes(:event).to_a
  end
end
