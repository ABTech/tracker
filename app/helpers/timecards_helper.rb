module TimecardsHelper
  def format_timecard_date( date )
    date.strftime("%m/%d/%y")
  end

  def format_time(hours)
    sprintf("%2d:%02d",hours.to_i, (hours*60)%60)
  end
end
