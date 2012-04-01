# == Schema Information
# Schema version: 93
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

class Attachment < ActiveRecord::Base
  has_attached_file :attachment

  validates_attachment_presence :attachment

  belongs_to :event
  belongs_to :journal
end
