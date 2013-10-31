class LocationsOnDates < ActiveRecord::Migration
    def self.up
        # create the eventdates location table 
        create_table("eventdates_locations", :id => false) do |t|
            t.column("eventdate_id", :integer, :null => false);
            t.column("location_id", :integer, :null => false);
        end

        # map all existing eventdate locations to event locations
        Eventdate.find(:all).each do |date|
            date.locations = date.event.locations;
            date.save();
        end
    end

    def self.down
        drop_table("eventdates_locations");
    end
end
