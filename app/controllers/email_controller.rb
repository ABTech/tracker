class EmailController < ApplicationController
    filter_parameter_logging :imappassword

    #require 'rmail.rb'
    require 'net/imap'

    before_filter :login_required;

    File_Action_File_Event        = "File with Event";
    File_Action_New_Event         = "newevent";
    File_Action_Existing_Event    = "oldevent";
    File_Action_Trash             = "Mark as Ignored";
    File_Action_Skip              = "Skip to Next";

    Event_ID_Offset               = 100000; # cause bigger numbers are better
    Event_ID_Regex                = /\[event ([0-9]+)\]/

    # take an email subject and try to find event IDs within it
    def self.find_eventids(str)
        return str.scan(Event_ID_Regex).collect {|match| match.first.to_i() - Event_ID_Offset }
    end
    # take an event and generate the subject string
    def self.generate_eventid(event)
        return (event.id + Event_ID_Offset).to_s();
    end

    def pull_email
        flash[:notice] = "";
        flash[:error]  = "";

        # first, connect to the IMAP server
        imap = Net::IMAP.new(EmailHelper::IMAP_Server, EmailHelper::IMAP_Port, true); # last is to use SSL
        begin
            imap.login(params['imapuser'], params['imappassword']);
        rescue
            flash[:error] = "Error while logging in.";
            redirect_to(:action => "list");
            return;
        end
        imap.select('user.abtech.todo')

        # messages we've saved locally, to be flagged so we don't
        # pull them again
        saved_set = [];

        # this could become "unread" or "every message" (and delete
        # them after importing) if this webapp reaches maturity.
        imap.search(["UNFLAGGED"]).each do |message_id|
            # download the message
            fetchd = imap.fetch(message_id, ["RFC822", "BODYSTRUCTURE", "ENVELOPE"])[0];
            envelope = fetchd.attr["ENVELOPE"]

            # create our local message
            message = Email.new();
	    message.event_id = 0;
            message.status      = Email::Email_Status_Unfiled;
            if(envelope.reply_to && (envelope.reply_to.size() > 0))
                message.sender      = envelope.reply_to[0].mailbox + '@' + envelope.reply_to[0].host;
            else
                message.sender      = envelope.from[0].mailbox + '@' + envelope.from[0].host;
            end

            message.timestamp   = DateTime.parse(envelope.date);
            message.subject     = envelope.subject;
	    message.message_id  = envelope.message_id;

            message.contents = "";
            message.contents << "Email received at #{envelope.date} from ABTT at #{DateTime.now()}.\n";

            # conveniently the formats are all the same, so just look through a 
            # list of parameters to check for addresses
            addresses_to_add = ["from", "reply_to", "to", "cc", "bcc"];
            addresses_to_add.each do |prop|
                val = eval("envelope.#{prop}");
                if(val)
                    val.each do |addr|
                        message.contents << "#{prop}: #{addr.mailbox}@#{addr.host} (#{addr.name})\n"
                    end
                end
            end

            message.contents << "\n";
            # get the actual contents, finding the text multipart segment
            # if we've got a multipart message (a message with attachment)
            structure = fetchd.attr["BODYSTRUCTURE"];
            if(structure.multipart?)
                flash[:notice] << "(multipart message)\n";
                message.contents << imap.fetch(message_id, ["BODY[1]"])[0].attr["BODY[1]"] << "\n";
            else
                message.contents << fetchd.attr["RFC822"] << "\n";
            end

            # save our local message
            if(!message.valid?)
                flash[:error] << "Unable to save local message from #{envelope.from[0].name} with subject #{envelope.subject}.\n";
                message.errors.each_full do |err|
                    flash[:error] << "--< #{err}\n";
                end
            else
                automatch = EmailController.find_eventids(message.subject);

                # if we can find the eventid in the subject, auto match that to
                # the event, to save some filing work
                if(!automatch.empty? && (automatch.length == 1))
                    message.status = Email::Email_Status_New;
                    message.event_id = automatch[0];
                    flash[:notice] << "Autofiled ";

                    # if we sent the message, mark it as read
                    if(EmailHelper::SMTP_From == message.sender())
                        message.status = Email::Email_Status_Read;
                        flash[:notice] << "sent message ";
                    end
                end

                message.save!();
                flash[:notice] << "Retreived message from #{envelope.from[0].name} with subject #{envelope.subject}.<br/>";

                saved_set << fetchd.seqno;
            end
        end

        if(!saved_set.empty?)
            # store the flages for pulled messages
            imap.store(saved_set, "+FLAGS", [:Flagged]);
        end

        imap.close();
        redirect_to(:action => "file");
    end

    def file
        @title = "Filing Messages";
        
        begin
            @skip = params['skip'].to_i();
        rescue
            @skip = 0;
        end

        if(params['id'] && Email.find(params['id']))
            email = Email.find(params['id']);

            case(params['commit'])
            when File_Action_File_Event
                case(params['fileaction'])
                when File_Action_New_Event
                    event = Event.new(params['event']);
                    event.year_id = Year.active_year.id;
                    EventHelper.update_event(event, params);
                    if(!event.save())
                        flash[:error] = "";
                        event.errors.each_full() do |err|
                            flash[:error] += err + "<br />";
                        end
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
                        email.errors.each_full() do |err|
                            flash[:error] += err + "<br />";
                        end
                    end
                end
            when File_Action_Trash
                email.status = Email::Email_Status_Ignored;
                if(!email.save())
                    flash[:error] = "";
                    email.errors.each_full() do |err|
                        flash[:error] += err + "<br />";
                    end
                end
            when File_Action_Skip
                @skip = @skip + 1;
            else
                flash[:error] = "Invalid action to file."
            end
        end

        # find the first unfiled email, by date, and file it
        emails = Email.find(:all, 
                    :order => "timestamp ASC", 
                    :conditions => "status = \"#{Email::Email_Status_Unfiled}\"", 
                    :offset => @skip,
                    :limit => 1);

        if(emails.size == 0)
            flash[:notice] = "No unfiled email to resolve.";
            redirect_to(:action => "list");
            return;
        end

        @email = emails.first;
        # default action:
        @fileaction = File_Action_Existing_Event;

        @event = EventHelper.generate_new_event();
        @event.title = @email.subject;
        @event.contactemail = @email.sender;
        if (@email.contents =~ /from:.*\((.*)\)/)
            @event.contact_name = $1;
        end
        if (@email.contents =~ /\s(\(?\d{3}\)?\D\d{3}\D\d{4})\s/)
            @event.contact_phone = $1;
        end

        render(:action => "file");
    end

    def unfile
        email = Email.find(params['id']);
        if(!email)
            flash[:error] = "No valid email specified.";
        else
            email.status = Email::Email_Status_Unfiled;
            email.event = nil;
            email.save();
        end

        redirect_to({:action => "list", :id => email.id});
    end

    def mark_status
        emails = Email.find(params['id'].split("."));
        if(!emails)
            flash[:error] = "Invalid ID.";
            return;
        end

        flash[:error] = "";

        emails.each do |rec|
            rec.status = params['status'];
            if(!rec.save())
                rec.errors.each_full() do |err|
                    flash[:error] += err + "<br />";
                end
            end
        end

        render(:text => "<html>Done.</html>");
    end

    def reply_to
        @title = "Send Reply"

        @email = Email.find(params['id']);
        if(!@email)
            flash[:error] = "Invalid ID.";
            return;
        end

        @title = "Re: #{@email.subject}"

        @outgoingemail = Email.new();
        @outgoingemail.timestamp = DateTime.now();
        @outgoing_destination = @email.sender;
        @outgoing_cc = EmailHelper::SMTP_CC_List.join(", ");
        @outgoing_from = EmailHelper::SMTP_From;
	@outgoing_inreplyto = @email.message_id;

        # if the old subject didn't have the eventid tag, add it
        if(EmailController.find_eventids(@email.subject).empty?)
            @outgoingemail.subject = "Re: [event #{EmailController.generate_eventid(@email.event)}] #{@email.subject}";
        else
            # if the old subject had eventid tag, and a leading "Re: "
            if(@email.subject[0,3] == "Re:")
                # use the old subject
                @outgoingemail.subject = @email.subject;
            else
                # if the old subject had eventid tag, and no leading "Re: ", add one
                @outgoingemail.subject = "Re: #{@email.subject}";
            end
        end
        @outgoingemail.contents = "\nOn #{@email.timestamp.strftime('%b %d, %Y at %I:%M %p')}, #{@email.sender} wrote:\n\n"

        @email.headerless_contents.each_line do |line|
            @outgoingemail.contents << "> " + line;
        end
    end

    def send_email
        @title = "Email sent";

        srcmsg = nil;
        if(params['id'])
            srcmsg = Email.find(params['id']);
            if(!srcmsg)
                flash[:error] = "Invalid ID.";
                return;
            end
        end

        # build the outgoing message
        msg = RMail::Message.new();
        hdr = msg.header;
        hdr.from = params['outgoingfrom'];
        hdr.to = params['outgoingto'].split(",");
        hdr.cc = params['outgoingcc'].split(",");
        #hdr.reply_to = params['outgoingreplyto'];
        hdr.subject = params['outgoingsubject'];
        hdr.date = Time.now();

        if (params['outgoinginreplyto'])
            hdr.add('In-Reply-To', params['outgoinginreplyto']);
        end

        msg.body = params['outgoingcontents'];

        toaddrs = hdr.to.addresses() | hdr.cc.addresses();

        Net::SMTP.start(EmailHelper::SMTP_Server, EmailHelper::SMTP_Port, EmailHelper::SMTP_Domain) do |smtp|
            smtp.send_message(msg.to_s(), hdr.from.first.address(), toaddrs);
            smtp.finish();
        end

        if(srcmsg)
            srcmsg.status = Email::Email_Status_Read;
            srcmsg.save();
        end

        # we don't save it locally because we expect all the messages to
        # be received on the typical pull schedule; otherwise we end
        # up pulling messages twice. (this method has the advantage that
        # messages sent from abtech@ by people not using the tracker can
        # still be imported to the db)
    end

    def new_thread
        @title = "New Email"

        @event = Event.find(params['id']);
        if(!@event)
            flash[:error] = "Invalid ID.";
            return;
        end

        @title = "New Email"

        @outgoingemail = Email.new();
        @outgoingemail.timestamp = DateTime.now();
        @outgoing_destination = @event.contactemail;
        @outgoing_cc = EmailHelper::SMTP_CC_List.join(", ");
        @outgoing_from = EmailHelper::SMTP_From;

        # if the old subject didn't have the eventid tag, add it
        @outgoingemail.subject = "[event #{EmailController.generate_eventid(@event)}]: #{@event.title}";

        render :action => "reply_to"
    end

    def list
        @title = "Email List";
        size = 20
        page = params[:page].to_i
        page = 1 if page < 1
        @emails = Email.find(:all, :order => 'timestamp DESC', :limit => size, :offset => size*(page-1))
        @previous = page - 1 if page > 1
        @next = page + 1 if page*size < Email.find_by_sql('select count(*) as count_all from emails')[0].count_all.to_i
    end

    def view
        @title = "Viewing Message"

        @email = Email.find(params["id"]);
    end
end
