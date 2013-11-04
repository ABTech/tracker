class Event < ActiveRecord::Base
  belongs_to :organization
  belongs_to :year
end
