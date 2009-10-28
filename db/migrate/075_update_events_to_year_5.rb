class UpdateEventsToYear5 < ActiveRecord::Migration
    def self.up
        # create 2008-2009 and make it active
        Year.create(:description => "2008-2009", :active => 1);
        
        # deactivate 2007-2008
        current_year = Year.find(4);
        current_year.active = 0;
        current_year.save();
        
        # set all events made in 2008-2009 to year_id = 5
        Event.find(:all, :conditions => "id > 537").each do |evt|
            evt.year_id = 5;
            evt.save();
        end
    end
    
    def self.down
        
    end
end