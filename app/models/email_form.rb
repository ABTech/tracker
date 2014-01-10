class EmailForm < ActiveRecord::Base
  validates_presence_of :description, :contents;
end
