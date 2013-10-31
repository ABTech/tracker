# == Schema Information
#
# Table name: accounts
#
#  id        :integer          not null, primary key
#  name      :string(255)      not null
#  is_credit :boolean          not null
#  position  :integer          not null
#

class AccGroup < Account

    def balance
        return '&nbsp;'
    end

end
