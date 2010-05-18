# Methods added to this helper will be available to all templates in the application.
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
            link_to_remote(title, { :url => {:controller => controller, :action => action}, :update => update }, html)
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
     request.env["HTTP_USER_AGENT"] && request.env["HTTP_USER_AGENT"][/(Mobile\/.+Safari)/]
   end

   def app_version
     begin
       IO.read("REVISION")[0,7]
     rescue
       "?"
     end
   end
end
