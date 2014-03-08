class Journal < ActiveRecord::Base
  belongs_to :account
  belongs_to :invoice
  belongs_to :event
  belongs_to :allocation
  has_many :attachments

  validates_presence_of :date, :memo, :amount, :account
  def date_s
    date.strftime('%B %d %Y')
  end

  def date_paid_s
    date_paid.strftime('%B %d %Y')
  end
end
