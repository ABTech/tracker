# == Schema Information
#
# Table name: timecards
#
#  id           :integer          not null, primary key
#  billing_date :datetime
#  due_date     :datetime
#  submitted    :boolean
#  start_date   :datetime
#  end_date     :datetime
#

require File.dirname(__FILE__) + '/../test_helper'

class TimecardTest < Test::Unit::TestCase
  fixtures :timecards

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
