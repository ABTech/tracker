require 'net/imap'

class EmailController < ApplicationController
  File_Action_File_Event        = "File with Event";
  File_Action_New_Event         = "newevent";
  File_Action_Existing_Event    = "oldevent";
  File_Action_Trash             = "Mark as Ignored";
  File_Action_Skip              = "Skip to Next";

  Event_ID_Offset               = 100000; # cause bigger numbers are better
  Event_ID_Regex                = /\[event ([0-9]+)\]/

    # take an email subject and try to find event IDs within it
    def self.find_eventids(str)
        return str.scan(Event_ID_Regex).collect {|match| match.first.to_i() - Event_ID_Offset } unless str.nil?
    end
    # take an event and generate the subject string
    def self.generate_eventid(event)
        return (event.id + Event_ID_Offset).to_s();
    end

    def pull_email
        authorize! :create, Email
        
        # first, connect to the IMAP server
        imap = Net::IMAP.new(EmailHelper::IMAP_Server, EmailHelper::IMAP_Port, true); # last is to use SSL
        begin
            imap.login(params['imapuser'], params['imappassword']);
        rescue
            flash[:error] = "Error while logging in.";
            redirect_to :action => "index"
            return;
        end
        imap.select('user.abtech')
        
        # if we've never pulled emails before, pull all emails that arrived
        # before tomorrow. otherwise, pull all emails that arrived on or after
        # the day of the last arrived email.
        query = ["BEFORE", Net::IMAP.format_date(Time.now + 1.day)]
        latest = Email.order("timestamp DESC").limit(1).first
        query = ["SINCE", Net::IMAP.format_date(latest.timestamp)] if latest

        imap.search(query).each do |message_id|
            # download the message
            fetchd = imap.fetch(message_id, ["RFC822", "BODYSTRUCTURE", "ENVELOPE"])[0]
            mail = Mail.new(fetchd.attr["RFC822"])
            envelope = fetchd.attr["ENVELOPE"]
            
            # imap can only query messages based on day of pull, not time, so we
            # have to manually filter out the ones we've already pulled
            if not latest or DateTime.parse(envelope.date) > latest.timestamp
                # create our local message
                message = Email.new()
                message.status = Email::Email_Status_Unfiled
                if envelope.reply_to and envelope.reply_to.size > 0
                    message.sender = envelope.reply_to[0].mailbox + '@' + envelope.reply_to[0].host
                else
                    message.sender = envelope.from[0].mailbox + '@' + envelope.from[0].host
                end

                message.timestamp   = DateTime.parse(envelope.date)
                message.subject = Mail::Encodings.value_decode(envelope.subject).encode("US-ASCII", {:invalid => :replace, :undef => :replace, :replace => ''})
                message.message_id  = envelope.message_id

                message.headers = "Email received at #{envelope.date} from ABTT at #{DateTime.now()}.\n"

                # conveniently the formats are all the same, so just look through a 
                # list of parameters to check for addresses
                addresses_to_add = ["from", "reply_to", "to", "cc", "bcc"]
                addresses_to_add.each do |prop|
                    val = eval("envelope.#{prop}")
                    if val
                        val.each do |addr|
                            message.headers << "#{prop}: #{addr.mailbox}@#{addr.host} (#{addr.name})\n"
                        end
                    end
                end
                
                message.event_id = nil

                # get the actual contents, finding the text multipart segment
                # if we've got a multipart message (a message with attachment)
                parts = collapse_multipart_tree(mail)
                textpart = parts.find { |p| p.content_type.starts_with? "text/plain" }
                htmlpart = parts.find { |p| p.content_type.starts_with? "text/html" }
                
                if textpart
                  message.contents = textpart.body.decoded
                elsif htmlpart
                  message.contents = Sanitize.clean(htmlpart.body.decoded)
                else
                  flash[:error] = "The email \"" + message.subject + "\" has no text part or html part. Please check it out in the webmail and deal with it accordingly."
                  break
                end
                                
                # cyrus returns buggy unicode data in the guise of 8-bit ascii.
                # just filter out any bytes with a value over 127 and pretend
                # it never happened.
                message.contents = message.contents.bytes.select { |c| c < 128 }.pack('c*')
                message.contents.encode!("UTF-8")

                # save our local message
                if message.valid?
                    automatch = EmailController.find_eventids(message.subject)

                    # if we can find the eventid in the subject, auto match that to
                    # the event, to save some filing work
                    if automatch and !automatch.empty? and automatch.length == 1
                        message.status = Email::Email_Status_New
                        message.event_id = automatch[0]

                        # if we sent the message, mark it as read
                        if EmailHelper::SMTP_From == message.sender
                            message.status = Email::Email_Status_Read
                        end
                    end

                    message.save!
                end
            end
        end

        imap.close()
        redirect_to(:action => "file", :next => "continue")
    end

    def file
        @title = "Filing Messages";
        
        begin
            @skip = params['skip'].to_i();
        rescue
            @skip = 0;
        end

        if(params['id'] && Email.find(params['id']))
            email = Email.find(params['id'])
            authorize! :update, email

            case(params['commit'])
            when File_Action_File_Event
                case(params['fileaction'])
                when File_Action_New_Event
                    event = Event.new(params.require(:event).permit(:title, :org_type, :organization_id, :org_new, :status, :blackout, :rental, :publish, :contact_name, :contactemail, :contact_phone, :price_quote, :notes, :eventdates_attributes => [:startdate, :description, :enddate, :calldate, :strikedate, :call_type, :strike_type, {:location_ids => []}, {:equipment_ids => []}, :call_literal, :strike_literal], :event_roles_attributes => [:role, :member_id], :attachments_attributes => [:attachment, :name]))

                    if(!event.save())
                        flash[:error] = "Error saving the event"
                        @fileaction = File_Action_New_Event
                        @email = email
                        @event = event
                        @skip = params[:skip]
                        @next = params[:next]
                        render
                        return
                    else
                        flash[:notice] = "Event Saved";
                        email.status = Email::Email_Status_New;
                        email.event = event;
                        if(!email.save())
                            flash[:error] = "";
                            email.errors.each_full() do |err|
                                flash[:error] += err + "<br />";
                            end
                        end
                    end
                when File_Action_Existing_Event
                    email.event_id = params['email']['event_id'];
                    email.status = Email::Email_Status_New;
                    if(!email.save())
                        flash[:error] = "";
                        email.errors.each do |err|
                            flash[:error] += err + "<br />";
                        end
                    end
                end
            when File_Action_Trash
                email.status = Email::Email_Status_Ignored;
                if(!email.save())
                    flash[:error] = "";
                    email.errors.each do |err|
                        flash[:error] += err + "<br />";
                    end
                end
            when File_Action_Skip
                @skip = @skip + 1;
            else
                flash[:error] = "Invalid action to file."
            end
        end

        if params[:next] == "continue"
          # find the first unfiled email, by date, and file it
          emails = Email.find(:all, 
                      :order => "timestamp ASC", 
                      :conditions => "status = \"#{Email::Email_Status_Unfiled}\"", 
                      :offset => @skip,
                      :limit => 1)

          if(emails.size == 0)
              flash[:notice] = "No unfiled email to resolve.";
              redirect_to :action => "index"
              return;
          end

          @email = emails.first
        
          redirect_to :action => "view", :id => @email.id, :skip => @skip, :next => "continue"
        else
          redirect_to view_email_url(params[:id])
        end
    end

    def unfile
        email = Email.find(params['id'])
        authorize! :update, email
        
        if(!email)
            flash[:error] = "No valid email specified.";
        else
            email.status = Email::Email_Status_Unfiled;
            email.event = nil;
            email.save();
        end

        redirect_to :action => "index"
    end

    def index
      @title = "Email List";

      authorize! :read, Email
      
      @emails = Email.paginate(:per_page => 20, :page => params[:page]).order("timestamp DESC")
      @file_email = Email.where(status: Email::Email_Status_Unfiled).order("timestamp ASC").first
    end

    def view
        @title = "Viewing Message"

        @email = Email.find(params["id"])
        authorize! :read, @email
        
        if @email.status == Email::Email_Status_Unfiled
          @fileaction = File_Action_Existing_Event
          
          @event = Event.new
          @event.title = @email.subject
          @event.contactemail = @email.sender
          if (@email.contents =~ /from:.*\((.*)\)/)
              @event.contact_name = $1
          end
          if (@email.contents =~ /\s(\(?\d{3}\)?\D\d{3}\D\d{4})\s/)
              @event.contact_phone = $1
          end
        end
        
        if params[:skip]
          @skip = params[:skip]
        end
        
        if params[:next]
          @next = params[:next]
        end
        
        render :action => "file"
    end
    
  private
    def collapse_multipart_tree(part)
      if part.multipart?
        part.parts.flat_map { |p| collapse_multipart_tree(p) }
      else
        [part]
      end
    end
end
