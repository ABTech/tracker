xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "ABTech Tracker Callsfeed"
    xml.description "A feed to generate GroupMe messages before show calls"
    xml.link events_url

    for ed in @calls
      xml.item do
        xml.title "Call for " + ed.event.title + " - " + ed.description + " at " + ed.calldate.strftime("%H:%M")
        xml.description ""
        xml.pubDate (ed.calldate - 30.minutes).to_s(:rfc822)
        xml.link event_url(ed.event)
        xml.guid event_url(ed.event)
      end
    end
  end
end