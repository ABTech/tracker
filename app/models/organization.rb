# == Schema Information
# Schema version: 93
#
# Table name: organizations
#
#  id        :integer(11)     not null, primary key
#  name      :string(255)     default(""), not null
#  parent_id :integer(11)
#

class Organization < ActiveRecord::Base
  has_many :events;
  
  validates_presence_of :name;
end
