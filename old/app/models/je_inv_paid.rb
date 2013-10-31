# == Schema Information
#
# Table name: journals
#
#  id               :integer          not null, primary key
#  created_at       :datetime
#  date             :datetime         not null
#  memo             :string(255)      not null
#  invoice_id       :integer
#  amount           :decimal(9, 2)    default(0.0), not null
#  date_paid        :datetime
#  notes            :text
#  account_id       :integer          default(1), not null
#  event_id         :integer
#  paymeth_category :string(255)      default("")
#

class JeInvPaid < Journal
    belongs_to :invoice, :foreign_key => "link_id";
end
