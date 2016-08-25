class Comment < ApplicationRecord
  belongs_to :member
  belongs_to :event
  
  validates :content, presence: true

  #attr_accessible :content
end
