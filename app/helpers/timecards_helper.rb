module TimecardsHelper
  def format_timecard_date( date )
    date.strftime("%m/%d/%y")
  end

  def format_time(hours)
    sprintf("%2d:%02d",hours.to_i, (hours*60)%60)
  end

  def timecards_for_select(past)
    past.map do |timecard|
      [timecard.billing_date.strftime("%b %d %Y"), timecard_url(timecard)]
    end
  end
end
