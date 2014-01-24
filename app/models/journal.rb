class Journal < ActiveRecord::Base
  belongs_to :account, :class_name => "Account", :foreign_key => "account_id";
  belongs_to :invoice, :class_name => "Invoice", :foreign_key => "invoice_id";
  belongs_to :event, :class_name => "Event", :foreign_key => "event_id";
  has_many :attachments

  #attr_accessible :date, :memo, :invoice_id, :amount, :date_paid, :notes, :account_id, :event_id, :paymeth_category

  validates_presence_of :date, :memo, :amount, :account;
  def date_s
    date.strftime('%B %d %Y')
  end

  def date_paid_s
    date_paid.strftime('%B %d %Y')
  end
end
