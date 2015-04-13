module EmailHelper
  IMAP_Server           = "imap.gmail.com";
  IMAP_Port             = 993;

  SMTP_Server           = "localhost"
  SMTP_Domain           = "andrew.cmu.edu"
  SMTP_Port             = 25;
  SMTP_CC_List          = ["abtech@andrew.cmu.edu"];
  SMTP_From             = "abtech@andrew.cmu.edu";
  SMTP_Reply_To         = "abtech@andrew.cmu.edu";
  
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
    
end
