class CreatingIndexes < ActiveRecord::Migration
  def self.up
    add_index("emails", "event_id");
    add_index("emails", "sender");
    add_index("emails", "subject");

    add_index("equipment", "description");
    add_index("equipment", "parent_id");
    add_index("equipment_categories", "name");
    add_index("equipment_categories", "parent_id");

    add_index("event_roles", "event_id");
    add_index("event_roles", "member_id");
    add_index("event_roles", "role");

    add_index("eventdates", "event_id");
    add_index("eventdates", "startdate");
    add_index("eventdates", "enddate");
    add_index("eventdates", "description");
    
    add_index("events", "title");
    add_index("events", "status");

    change_column("events", "contactemail", :string);
    change_column("events", "contactdetail", :text);

    add_index("events", "contactemail");
    add_index("events", "location_id");

    add_index("events_locations", "event_id");
    add_index("events_locations", "location_id");

    add_index("members", "namefirst");
    add_index("members", "namelast");
    add_index("members", "kerbid");

    add_index("organizations", "name");


  end

  def self.down
  end
end
