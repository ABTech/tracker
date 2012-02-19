require File.dirname(__FILE__) + '/../test_helper'

class TimecardEntryTest < Test::Unit::TestCase
  fixtures :timecard_entries

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end

# == Schema Information
#
# Table name: timecard_entries
#
#  id           :integer(11)     not null, primary key
#  member_id    :integer(11)
#  hours        :float
#  eventdate_id :integer(11)
#  timecard_id  :integer(11)
#  payrate      :float
#

