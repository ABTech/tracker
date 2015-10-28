require 'logger'

namespace :email do
  desc "Check for email continuously in the background"
  task :idle => :environment do
    STDOUT.sync = true
    
    logger = Logger.new(STDOUT)
    logger.level = Logger::INFO
    
    config = YAML.load_file(Rails.root.join("config", "email.yml"))
    
    reconnectSleep = 1
    
    logger.info("Logging in to mailbox #{config[:email]}")
    while true
      begin
        imap = Net::IMAP.new(config[:host], port: config[:port], ssl: config[:ssl])
        oauth_client = OAuth2::Client.new(config[:client_id], config[:client_secret], {site: 'https://accounts.google.com', authorize_url: '/o/oauth2/auth', token_url: '/o/oauth2/token'})
        access_token = OAuth2::AccessToken.from_hash(oauth_client, refresh_token: config[:refresh_token]).refresh!
        imap.authenticate('XOAUTH2', config[:email], access_token.token)
      rescue Net::IMAP::NoResponseError, SocketError, Faraday::ConnectionFailed
        logger.info("Could not authenticate for #{config[:email]}, trying again in #{reconnectSleep} #{"second".pluralize(reconnectSleep)}")
        sleep reconnectSleep
        reconnectSleep += 1
        
        next
      end
      
      reconnectSleep = 1
      
      begin
        imap.select(config[:name])
        
        while true
          logger.info("Pulling emails for #{config[:email]}")
          query = ["BEFORE", Net::IMAP.format_date(Time.now + 1.day)]
          latest = Email.order("timestamp DESC").first
          query = ["SINCE", Net::IMAP.format_date(latest.timestamp)] if latest
          
          ids = imap.search(query)
          imap.fetch(ids, "BODY.PEEK[]").each do |msg|
            mail = Mail.new(msg.attr["BODY[]"])
            
            unless Email.where(message_id: mail.message_id).exists?
              unless Email.create_from_mail(mail)
                logger.error("Could not pull message #{mail.message_id}")
              end
            end
          end
          
          logger.info("Idling for #{config[:email]}")
          
          waiting = Thread.start do
            sleep(20.minutes)
            
            imap.idle_done
          end
          
          imap.idle do |response|
            if response.respond_to?(:name) && response.name == 'EXISTS'
              waiting.kill
              imap.idle_done
            end
          end
        end
      rescue Net::IMAP::Error, EOFError, Errno::ECONNRESET => e
        logger.info("Disconnected for mailbox #{config[:email]}, reconnecting")
        next
      end
    end
  end
end
