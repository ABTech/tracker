require 'logger'

namespace :slack do
  desc "Notify the Slack about upcoming calls and strikes"
  task :notify => :environment do
    STDOUT.sync = true
    
    logger = Logger.new(STDOUT)
    

    Rails.application.credentials.fetch(:slack) { raise 'Could not find `slack` credentials!' }
    Rails.application.credentials.slack.fetch(:token) { raise 'Could not find `token` in `slack` credentials!' }
    env_config = Rails.application.credentials.slack
    
    logger.info("Logging into Slack")
    Slack.configure do |config|
        config.token = env_config[:token]
    end
    client = Slack::Web::Client.new
    
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
      client.chat_postMessage(channel: '#events', text: message, as_user: true)
    end
  end
end
