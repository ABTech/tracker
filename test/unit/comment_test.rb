# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  member_id  :integer
#  content    :text
#  event_id   :integer
#  created_at :datetime
#  updated_at :datetime
#

require File.dirname(__FILE__) + '/../test_helper'

class CommentTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
