# == Schema Information
# Schema version: 80
#
# Table name: member_filters
#
#  id           :integer(11)     not null, primary key
#  name         :string(255)     default("new filter"), not null
#  filterstring :string(255)
#  displaylimit :integer(11)     default(0), not null
#  member_id    :integer(11)     not null
#

class MemberFilter < ActiveRecord::Base
    belongs_to :member;

    validates_presence_of :name, :displaylimit;

    def filters
        if(filterstring)
            return filterstring.split(",");
        else
            return []
        end
    end

    def filters=(what)
        self.filterstring = what.join(",");
    end
end
