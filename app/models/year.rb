# == Schema Information
#
# Table name: years
#
#  id          :integer          not null, primary key
#  description :string(255)      not null
#  active      :integer          default(0), not null
#

class Year < ActiveRecord::Base
    has_many :events;
    has_many :accounts;

    def self.active_year
        return Year.find(:first, :order => "id DESC", :conditions => "active = 1");
    end
end
