require 'logger'

namespace :groupme do
  desc "Notify the GroupMe about upcoming calls and strikes"
  task :notify => :environment do
    STDOUT.sync = true
    
    logger = Logger.new(STDOUT)
    
    config = YAML.load_file(Rails.root.join("config", "groupme.yml"))
    
    logger.info("Logging into GroupMe")
    client = GroupMe::Client.new(:token => "TEST")
    
    startdate = DateTime.now
    enddate = 1.hour.from_now
    
    calls = Eventdate.where(events: {textable: true, status: Event::Event_Status_Group_Not_Cancelled}).call_between(startdate, enddate).includes(:event).references(:event)
    strikes = Eventdate.where(events: {textable: true, status: Event::Event_Status_Group_Not_Cancelled}).strike_between(startdate, enddate).includes(:event).references(:event)
    
    messages = calls.collect do |eventdate|
      "Call for " + eventdate.event.title + " - " + eventdate.description + " is at " + eventdate.effective_call.strftime("%H:%M")
    end + strikes.collect do |eventdate|
      "Strike for " + eventdate.event.title + " - " + eventdate.description + " is at " + eventdate.effective_strike.strftime("%H:%M")
    end
    
    unless messages.empty?
      message = messages.join("\n")
      
      logger.info("Sending message")
      client.bot_post(config[:bot_id], message)
    end
  end
end
