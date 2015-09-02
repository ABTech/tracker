namespace :email do
  desc "Check for email continuously in the background"
  task :idle => :environment do
    config = YAML.load_file(Rails.root.join("config", "email.yml"))
    imap = Net::IMAP.new(config[:host], port: config[:port], ssl: config[:ssl])
    
    oauth_client = OAuth2::Client.new(config[:client_id], config[:client_secret], {site: 'https://accounts.google.com', authorize_url: '/o/oauth2/auth', token_url: '/o/oauth2/token'})
    
    puts "Logging in to mailbox #{config[:email]}"
    while true
      access_token = OAuth2::AccessToken.from_hash(oauth_client, refresh_token: config[:refresh_token]).refresh!
      
      begin
        imap.authenticate('XOAUTH2', config[:email], access_token.token)
      rescue Net::IMAP::NoResponseError
        puts "Could not authenticate for #{config[:email]}, trying again"
        next
      end
      
      imap.select(config[:name])
      
      begin
        while true
          puts "Pulling emails for #{config[:email]}"
          query = ["BEFORE", Net::IMAP.format_date(Time.now + 1.day)]
          latest = Email.order("timestamp DESC").first
          query = ["SINCE", Net::IMAP.format_date(latest.timestamp)] if latest
          
          ids = imap.search(query)
          imap.fetch(ids, "RFC822").each do |msg|
            mail = Mail.new(msg.attr["RFC822"])
            Email.create_from_mail(mail)
          end
          
          puts "Idling for #{config[:email]}"
          imap.idle do |response|
            imap.idle_done if response.respond_to?(:name) && response.name == 'EXISTS'
          end
        end
      rescue Net::IMAP::Error, EOFError => e
        puts "Disconnected for mailbox #{config[:email]}, reconnecting"
        next
      end
    end
  end
end
