class DetailedEventDates < ActiveRecord::Migration
  def self.up
    add_column("eventdates", "description", :string);
  end
  
  def self.down
  end
end
