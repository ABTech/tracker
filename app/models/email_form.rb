class EmailForm < ApplicationRecord
  validates_presence_of :description, :contents
end
