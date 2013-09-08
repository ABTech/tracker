# == Schema Information
#
# Table name: locations
#
#  id       :integer          not null, primary key
#  building :string(255)      not null
#  floor    :string(255)      not null
#  room     :string(255)      not null
#  details  :text
#

class Location < ActiveRecord::Base
  has_and_belongs_to_many :eventdates
  
  validates_presence_of :building, :floor, :room;
  
  def to_s
    return (building + " - " + room);
  end
end
