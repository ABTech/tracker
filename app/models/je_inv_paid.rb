# == Schema Information
# Schema version: 93
#
# Table name: journals
#
#  id         :integer(11)     not null, primary key
#  created_at :datetime
#  date       :datetime        not null
#  memo       :string(255)     not null
#  invoice_id :integer(11)
#  amount     :decimal(9, 2)   default(0.0), not null
#  date_paid  :datetime
#  notes      :text
#  account_id :integer(11)     default(1), not null
#  event_id   :integer(11)
#

class JeInvPaid < Journal
    belongs_to :invoice, :foreign_key => "link_id";
end
