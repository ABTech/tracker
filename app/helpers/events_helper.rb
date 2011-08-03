module EventsHelper
    def self.generate_new_event()
        event = Event.new();
        EventsController::New_Event_New_Date_Display_Count.times do
            dt = Eventdate.new();
            dt.calldate = Time.now();
            dt.startdate = Time.now();
            dt.enddate = Time.now();
            dt.strikedate = Time.now();
            event.eventdates << dt;
        end

        EventsController::New_Event_New_Role_Display_Count.times do
            rl = EventRole.new();
            event.event_roles << rl;
        end
        event.organization = Organization.find(:first, :order => "name ASC", :limit => 1);

        return event;
    end

    def self.update_event(event, params)
        errors = "";
        notices = "";

        # -------------------
        # create new dates
        params['ndates'].to_i().times do |i|
            key = "date" + i.to_s();
            if(params[key]["id"] && ("" != params[key]["id"]))
                date = Eventdate.update(params[key]["id"], params[key]);

                # try to parse the string fields
                date.calldate = DateTime.parse(params[key]['calldate']);
                date.startdate = DateTime.parse(params[key]['startdate']);
                date.enddate = DateTime.parse(params[key]['enddate']);
                date.strikedate = DateTime.parse(params[key]['strikedate']);
            
                if(date.description == "")
                    date.destroy();
                elsif(date.valid?)
                    date.save();
                else
                    date.errors.each_full() do |err|
                        errors += err + "<br />";
                    end
                end
            else
                date = Eventdate.new(params['date' + i.to_s()]);
                date.event = event;

                if(date.valid?)
                    event.eventdates << date;
                elsif(date.description && (date.description != ""))
                    date.errors.each_full() do |err|
                        errors += err + "<br />";
                    end
                end
            end
        end
        
        # --------------------
        # create new roles
        params['nroles'].to_i().times do |i|
            if(params["role" + i.to_s()]["id"] && ("" != params["role" + i.to_s()]["id"]))
                if("" == params["role" + i.to_s()]["role"])
                    # delete it
                    EventRole.delete(params["role" + i.to_s()]["id"]);
                else
                    role = EventRole.find(params["role" + i.to_s()]["id"]);
                    role.attributes = params["role" + i.to_s()];
                    if(!role.assigned?)
                        role.member_id = 0;
                    end
                
                    role.errors.each_full() do |err|
                        errors += err + "<br />";
                    end
                    
                    if(role.valid?)
                        role.save();
                    end
                end
            else
                role = EventRole.new(params["role" + i.to_s()]);
                role.event = event;
                if(!role.assigned?)
                    role.member_id = 0;
                end

                if(role.valid?)
                    event.event_roles << role;
                elsif(role.role && !role.role.empty?)
                    role.errors.each_full() do |err|
                        errors += err + "<br />";
                    end
                end
            end
        end

        # is there a TIC?
        if(event.event_roles.reject{|role| role.role != EventRole::Role_TIC}.empty?)
            # add a "TIC" role by default
            ticrole = EventRole.new();
            ticrole.role = EventRole::Role_TIC;
            ticrole.member_id = 0;
            ticrole.event = event;
            event.event_roles << ticrole;
        end

        case(params['organization_select'])
        # --------------------
        # pull existing organization
        when EventsController::New_Event_Existing_Organization
          event.organization = Organization.find(params['organization_id']);
          
        # --------------------
        # create new organization
        when EventsController::New_Event_New_Organization
          neworg = Organization.new(params['organization']);
          event.organization = neworg;
        end

        return notices, errors;
    end


end
