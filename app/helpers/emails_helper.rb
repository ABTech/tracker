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
    if eventdate.tic
      "TiC - " + eventdate.tic.fullname
    elsif eventdate.exec
      "Exec - " + eventdate.exec.fullname
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
    
    ("<ul>" + headers.collect do |h|
      if h[:hidden]
        "<li class=\"hidden-header\">"
      else
        "<li>"
      end + "#{h[:title]}: #{h[:content]}</li>"
    end.join("") + "</ul>").html_safe
  end
    
end
