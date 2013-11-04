class AccDebit < Account
  def balance
    return total_debit - total_credit;
  end
end
