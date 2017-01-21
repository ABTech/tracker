module EmailsHelper

  def email_call_text(eventdate)
    if eventdate.has_call?
      eventdate.effective_call.strftime("%H:%M")
    else
      "TBD"
    end
  end
  
  def email_strike_text(eventdate)
    if eventdate.has_strike?
      eventdate.effective_strike.strftime("%H:%M")
    elsif eventdate.striketype == "none"
      "Not applicable"
    elsif eventdate.striketype == "blank"
      "TBD"
    end
  end
  
  def email_show_text(eventdate)
    eventdate.startdate.strftime("%H:%M") + " - " + eventdate.enddate.strftime("%H:%M")
  end
  
  def email_who_text(eventdate)
    if !eventdate.tic.empty?
      "TiC - " + eventdate.tic.map(&:display_name).join(", ")
    elsif eventdate.exec
      "Exec - " + eventdate.exec.display_name
    else
      "you?"
    end
  end
  
  def email_headers_display(email)
    headers = email.headers.split("\n").collect do |h|
      parts = h.split(": ")
      ht = parts.shift
      
      {
        :title => ht,
        :content => parts.join(": "),
        :hidden => (not (["from", "date", "subject", "to", "cc"].include?(ht.downcase)))
      }
    end
    
    "<ul>".html_safe + safe_join(headers.collect do |h|
      if h[:hidden]
        "<li class=\"hidden-header\">".html_safe
      else
        "<li>".html_safe
      end + h[:title] + ": " + h[:content] + "</li>".html_safe
    end) + "</ul>".html_safe
  end
  
  def email_thread(email)
    "<ul>".html_safe + email_thread_recur(email.make_tree) + "</ul>".html_safe
  end
  
  def email_thread_recur(thread)
    "<li>".html_safe + link_to_unless_current(thread[:email].subject, thread[:email]) +
    " by #{thread[:email].sender} on #{thread[:email].timestamp.strftime("%-m/%-d/%y %H:%M")}" +
    if thread[:children].empty?
      "".html_safe
    else
      "<ul>".html_safe + safe_join(thread[:children].collect do |child|
        email_thread_recur(child)
      end) + "</ul>".html_safe
    end + "</li>".html_safe
  end
  
  def form_emails_for_select
    EmailForm.all.map do |ef|
      [ ef.description, ef.id, { :data => { :contents => "" + ef.contents } } ]
    end
  end
    
end
