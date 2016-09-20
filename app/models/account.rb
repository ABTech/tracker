class Account

  def self.magic_date
    if Date.today.month < 7
      (Date.today.year - 1).to_s + '-07-01'
    else
      Date.today.year.to_s + '-07-01'
    end
  end
  
  def self.future_magic_date
    if Date.today.month < 7
      Date.today.year.to_s + '-07-01'
    else
      (Date.today.year + 1).to_s + '-07-01'
    end
  end

end
