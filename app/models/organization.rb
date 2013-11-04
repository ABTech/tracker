class Organization < ActiveRecord::Base
  has_many :events;

  validates_presence_of :name;
end
