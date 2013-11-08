class Attachment < ActiveRecord::Base
  belongs_to :event
  belongs_to :journal

  has_attached_file :attachment

  #TODO: Convert this properly
  #has_attached_file :avatar,
  #  :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
  #  :url => "/system/:attachment/:id/:style/:filename"

  validates_attachment_presence :attachment
end
