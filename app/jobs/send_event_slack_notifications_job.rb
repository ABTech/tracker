class SendEventSlackNotificationsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Rails.application.routes.default_url_options = Rails.application.config.action_mailer.default_url_options

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

    channel =
      if Rails.env.development?
        "#bot-testing"
      elsif Rails.env.staging?
        "#bot-testing"
      else
        "#events"
      end
    channel_social =
      if Rails.env.development?
        "#bot-testing"
      elsif Rails.env.staging?
        "#bot-testing"
      else
        "#social"
      end

    startdate = DateTime.now
    enddate = 1.hour.from_now
    
    calls = Eventdate.where(events: {textable: true, status: Event::Event_Status_Group_Not_Cancelled}).call_between(startdate, enddate).includes(:event).references(:event)
    strikes = Eventdate.where(events: {textable: true, status: Event::Event_Status_Group_Not_Cancelled}).strike_between(startdate, enddate).includes(:event).references(:event)

    def message_gen(msg, event_url, eventdate)
      [
        msg,
        {
          type: "section",
          text: {
            type: "mrkdwn",
            text: msg + "\n_" + eventdate.locations.join(", ") + "_"
          },
          accessory: {
            type: "button",
            text: {
              type: "plain_text",
              text: "View on Tracker",
              emoji: true,
            },
            url: event_url
          }
        }
      ]
    end

    messages = []
    messages_social = []
    calls.each do |eventdate|
      event_url = Rails.application.routes.url_helpers.url_for(eventdate.event).to_s
      msg = "Call for <" + event_url + "|" + eventdate.event.title + "> - " + eventdate.description + " is at " + eventdate.effective_call.strftime("%H:%M")
      messages.push(message_gen(msg, event_url, eventdate))
      messages_social.push(message_gen(msg, event_url, eventdate)) if eventdate.event.textable_social
    end
    strikes.each do |eventdate|
      event_url = Rails.application.routes.url_helpers.url_for(eventdate.event).to_s
      msg = "Strike for <" + event_url + "|" + eventdate.event.title + "> - " + eventdate.description + " is at " + eventdate.effective_strike.strftime("%H:%M")
      messages.push(message_gen(msg, event_url, eventdate))
      messages_social.push(message_gen(msg, event_url, eventdate)) if eventdate.event.textable_social
    end

    messages_text = messages.map { |msg| msg[0] }
    messages_blocks = messages.map { |msg| msg[1] }
    messages_social_text = messages_social.map { |msg| msg[0] }
    messages_social_blocks = messages_social.map { |msg| msg[1] }
    
    unless messages.empty?
      message_text = messages_text.join("\n")
      
      logger.info("Sending message")
      client.chat_postMessage(channel: channel, text: message_text, as_user: true, blocks: messages_blocks)
    end

    unless messages_social.empty?
      message_text = messages_social_text.join("\n")

      logger.info("Sending social message")
      client.chat_postMessage(channel: channel_social, text: message_text, as_user: true, blocks: messages_blocks)
    end

  end
end
