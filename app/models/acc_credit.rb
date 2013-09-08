# == Schema Information
#
# Table name: accounts
#
#  id        :integer          not null, primary key
#  name      :string(255)      not null
#  is_credit :boolean          not null
#  position  :integer          not null
#

class AccCredit < Account
    def balance
        return total_credit - total_debit;
    end
end
