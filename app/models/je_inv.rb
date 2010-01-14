# == Schema Information
# Schema version: 80
#
# Table name: journals
#
#  id         :integer(11)     not null, primary key
#  created_at :datetime
#  date       :datetime        not null
#  memo       :string(255)     not null
#  link_id    :integer(11)
#  amount     :decimal(9, 2)   default(0.0), not null
#  date_paid  :datetime
#  notes      :text
#  account_id :integer(11)     default(1), not null
#

class JeInv < Journal
    belongs_to :invoice, :foreign_key => "link_id";
    belongs_to :je_paid, :foreign_key => "link_paid_id";
end
