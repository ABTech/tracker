class AddNameAndPhone < ActiveRecord::Migration
    def self.up
        add_column("events", "contact_name", :string, :null => false, :default => "");
        add_column("events", "contact_phone", :string, :null => false, :default => "");
    end
    
    def self.down
        remove_column("events", "contact_name");
        remove_column("events", "contact_phone");
    end
end