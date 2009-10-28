# == Schema Information
# Schema version: 78
#
# Table name: years
#
#  id          :integer(11)     not null, primary key
#  description :string(255)     default(""), not null
#  active      :integer(11)     default(0), not null
#

class Year < ActiveRecord::Base
    has_many :events;
    has_many :accounts;

    def self.active_year
        return Year.find(:first, :order => "id DESC", :conditions => "active = 1");
    end
end
