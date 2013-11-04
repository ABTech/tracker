class AccCredit < Account
  def balance
    return total_credit - total_debit;
  end
end
