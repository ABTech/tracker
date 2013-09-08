# == Schema Information
#
# Table name: organizations
#
#  id        :integer          not null, primary key
#  name      :string(255)      default(""), not null
#  parent_id :integer
#  org_email :string(255)
#

class Organization < ActiveRecord::Base
  has_many :events;
  
  validates_presence_of :name;
end
