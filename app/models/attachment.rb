class Attachment < ApplicationRecord
  belongs_to :attachable, polymorphic: true

  has_one_attached :attachment
  validates :attachment, attached: true
  
  before_save :ensure_name
  
  def friendly_size
	  if (attachment.byte_size / 1024) < 1024
      (attachment.byte_size / 1024.0).ceil.to_s + " kB"
    else
      (attachment.byte_size / 1048576.0).to_s[0..3] + " MB"
    end
  end
  
  private
    def ensure_name
      self.name = self.attachment.filename if self.name.blank?
    end
end
