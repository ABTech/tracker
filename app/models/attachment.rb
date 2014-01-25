class Attachment < ActiveRecord::Base
  belongs_to :event
  belongs_to :journal

  has_attached_file :attachment, :url => "/system/attachments/:id/:style/:filename", :path => ":rails_root/public/system/attachments/:id/:style/:filename"

  validates_attachment_presence :attachment
  
  attr_accessible :attachment, :name
  
  before_save :ensure_name
  
  def friendly_size
	  if (attachment.size / 1024) < 1024
      (attachment.size / 1024.0).ceil.to_s + " kB"
    else
      (attachment.size / 1048576.0).to_s[0..3] + " MB"
    end
  end
  
  private
    def ensure_name
      self.name = self.attachment.original_filename if self.name.blank?
    end
end
