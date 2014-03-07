class Allocation < ActiveRecord::Base
  validates_uniqueness_of :line_item
end
