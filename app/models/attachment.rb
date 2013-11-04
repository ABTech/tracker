class Attachment < ActiveRecord::Base
  belongs_to :event
  belongs_to :journal

  has_attached_file :attachment

  validates_attachment_presence :attachment
end
