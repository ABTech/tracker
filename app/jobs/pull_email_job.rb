require 'logger'

class PullEmailJob < ApplicationJob
  queue_as :default

  def perform(*args)
    STDOUT.sync = true
    
    logger = Logger.new(STDOUT)
    logger.level = Logger::INFO
    
    Rails.application.credentials.fetch(:email) { raise 'Could not find `email` credentials!' }
    Rails.application.credentials.email.fetch(:email) { raise 'Could not find `email` in `email` credentials!' }
    Rails.application.credentials.email.fetch(:name) { raise 'Could not find `name` in `email` credentials!' }
    Rails.application.credentials.email.fetch(:port) { raise 'Could not find `port` in `email` credentials!' }
    Rails.application.credentials.email.fetch(:host) { raise 'Could not find `host` in `email` credentials!' }
    Rails.application.credentials.email.fetch(:ssl) { raise 'Could not find `ssl` in `email` credentials!' }
    # Cannot used nested hashes in credentials without [] in Rails 6
    # https://blog.saeloun.com/2021/06/02/rails-access-nested-secrects-by-method-call/
    if Rails.application.credentials.email[:oauth].nil? && Rails.application.credentials.email[:password].nil?
      raise 'Could not find `oauth` or `password` in `email` credentials!'
    elsif !Rails.application.credentials.email[:oauth].nil? && !Rails.application.credentials.email[:password].nil?
      raise 'Found both `oauth` and `password` in `email` credentials!'
    elsif !Rails.application.credentials.email[:oauth].nil?
      Rails.application.credentials.email[:oauth].fetch(:site) { raise 'Could not find `site` in `email.oauth` credentials!' }
      Rails.application.credentials.email[:oauth].fetch(:authorize_url) { raise 'Could not find `authorize_url` in `email.oauth` credentials!' }
      Rails.application.credentials.email[:oauth].fetch(:token_url) { raise 'Could not find `token_url` in `email.oauth` credentials!' }
      Rails.application.credentials.email[:oauth].fetch(:refresh_token) { raise 'Could not find `refresh_token` in `email.oauth` credentials!' }
      Rails.application.credentials.email[:oauth].fetch(:client_id) { raise 'Could not find `client_id` in `email.oauth` credentials!' }
      Rails.application.credentials.email[:oauth].fetch(:client_secret) { raise 'Could not find `client_secret` in `email.oauth` credentials!' }
    end
    config = Rails.application.credentials.email
    
    reconnectSleep = 1
    
    logger.info("Logging in to mailbox #{config[:email]}")

    begin
      imap = Net::IMAP.new(config[:host], port: config[:port], ssl: config[:ssl])
      imap.capable?(:IMAP4rev1) or raise "Not an IMAP4rev1 server"
      if imap.auth_capable?("XOAUTH2") && !Rails.application.credentials.email[:oauth].nil?
        oauth_client = OAuth2::Client.new(config[:oauth][:client_id], config[:oauth][:client_secret], {site: config[:oauth][:site], authorize_url: config[:oauth][:authorize_url], token_url: config[:oauth][:token_url]})
        access_token = OAuth2::AccessToken.from_hash(oauth_client, refresh_token: config[:oauth][:refresh_token]).refresh!
        imap.authenticate('XOAUTH2', config[:email], access_token.token)
      elsif imap.auth_capable?("PLAIN")
        imap.authenticate("PLAIN", config[:email], config[:password])
      # Should not use deprecated LOGIN method
      # elsif !imap.capability?("LOGINDISABLED")
        # imap.login(config[:email], config[:password])
      else
        raise "No acceptable authentication mechanisms"
      end
    rescue Net::IMAP::NoResponseError, SocketError, Faraday::ConnectionFailed => error
      logger.error("Could not authenticate for #{config[:email]}, error: #{error.message}")
      return
    end
    
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
            begin
              unless Email.create_from_mail(mail)
                logger.error("Could not pull message #{mail.message_id}")
              end
            rescue Exception => e
              logger.error("Exception while loading message #{mail.message_id}: " + e.to_s + "\n" + e.backtrace.join("\n"))
            end
          end
        end
      end
    rescue Net::IMAP::Error, EOFError, Errno::ECONNRESET => e
      logger.error("Disconnected for mailbox #{config[:email]}")
    end
  end
end
