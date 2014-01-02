class Attachment < ActiveRecord::Base
  belongs_to :event
  belongs_to :journal

  has_attached_file :attachment

  #TODO: Convert this properly
  #has_attached_file :avatar,
  #  :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
  #  :url => "/system/:attachment/:id/:style/:filename"

  validates_attachment_presence :attachment
  
  def friendly_size
	  if (attachment.size / 1024) < 1024
      (attachment.size / 1024.0).ceil.to_s + " kB"
    else
      (attachment.size / 1048576.0).to_s[0..3] + " MB"
    end
  end
end
