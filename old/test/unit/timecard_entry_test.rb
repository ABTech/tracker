# == Schema Information
#
# Table name: timecard_entries
#
#  id           :integer          not null, primary key
#  member_id    :integer
#  hours        :float
#  eventdate_id :integer
#  timecard_id  :integer
#  payrate      :float
#

require File.dirname(__FILE__) + '/../test_helper'

class TimecardEntryTest < Test::Unit::TestCase
  fixtures :timecard_entries

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
