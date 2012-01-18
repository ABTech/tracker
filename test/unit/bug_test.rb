require File.dirname(__FILE__) + '/../test_helper'

class BugTest < Test::Unit::TestCase
  fixtures :bugs

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end

# == Schema Information
#
# Table name: bugs
#
#  id           :integer(11)     not null, primary key
#  member_id    :integer(11)
#  submitted_on :datetime
#  description  :text            not null
#  confirmed    :boolean(1)      default(FALSE), not null
#  resolved     :boolean(1)      default(FALSE), not null
#  resolved_on  :datetime
#  comment      :text
#  closed       :boolean(1)      default(FALSE), not null
#  priority     :string(255)
#  created_on   :datetime
#  updated_on   :datetime
#

