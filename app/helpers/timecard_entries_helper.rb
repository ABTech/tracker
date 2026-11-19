module TimecardEntriesHelper
  def eventdate_select_options(eventdates_and_parts)
    eventdates_and_parts.collect do |e|
      label = [e[:eventdate].event.title, e[:eventdate].description, TimecardEntry.eventpart.options.rassoc(e[:eventpart]).first].join(' - ')
      value = "#{e[:eventdate].id}-#{e[:eventpart]}"
      [label, value, {"data-startdate" => e[:eventdate].startdate.iso8601}]
    end
  end

  def timecard_select_options(timecards)
    timecards.map do |t|
      [t.billing_date.strftime("%Y/%m/%d"), t.id, {"data-start" => t.start_date.iso8601, "data-end" => t.end_date.iso8601}]
    end
  end
end
