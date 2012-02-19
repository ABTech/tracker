# == Schema Information
# Schema version: 80
#
# Table name: accounts
#
#  id        :integer(11)     not null, primary key
#  name      :string(255)     not null
#  is_credit :boolean(1)      not null
#  position  :integer(11)     not null
#

class AccGroup < Account

    def balance
        return '&nbsp;'
    end

end
