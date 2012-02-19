# == Schema Information
# Schema version: 80
#
# Table name: eventdates
#
#  id          :integer(11)     not null, primary key
#  event_id    :integer(11)     not null
#  startdate   :datetime        not null
#  enddate     :datetime        not null
#  calldate    :datetime        not null
#  strikedate  :datetime        not null
#  description :string(255)     not null
#

class Eventdate < ActiveRecord::Base
    belongs_to :event;
    has_many :timecard_entries
    has_and_belongs_to_many :locations;
    has_and_belongs_to_many :equipment;

    validates_presence_of :startdate, :enddate, :description, :event, :locations;
    validates_associated :locations, :equipment;

    Event_Span_Days       = 2;
    Event_Span_Seconds    = Event_Span_Days * 24 * 60 * 60;
  
    def valid_call?
        return (calldate &&
                (calldate.to_i < startdate.to_i) &&
                ((startdate.to_i - calldate.to_i) < Event_Span_Seconds));
    end

    def valid_strike?
        return (strikedate &&
                (strikedate.to_i >= enddate.to_i) &&
                ((strikedate.to_i - enddate.to_i) < Event_Span_Seconds));
    end
end
