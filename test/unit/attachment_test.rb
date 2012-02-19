require File.dirname(__FILE__) + '/../test_helper'

class AttachmentTest < Test::Unit::TestCase
  fixtures :attachments

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end

# == Schema Information
#
# Table name: attachments
#
#  id                      :integer(11)     not null, primary key
#  name                    :string(255)
#  attachment_file_name    :string(255)
#  attachment_content_type :string(255)
#  attachment_file_size    :integer(11)
#  attachment_updated_at   :datetime
#  event_id                :integer(11)
#  updated_at              :datetime
#  created_at              :datetime
#

