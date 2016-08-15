class Account < ApplicationRecord
  has_many :journals, -> { order "journals.date DESC" }
    
  validates_presence_of :name, :position;
  validates_inclusion_of :is_credit, :in => [true, false];

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
  		
  # Credit
  Credit_Accounts = Account.where(is_credit: true)
  Events_Account = Account.find(1)
  Rentals_Credit_Account = Account.find(2)
  CMU_Account = Account.find(3)
  Misc_Credit_Account = Account.find(4)

  # Debit
  Debit_Accounts = Account.where(is_credit: false)
  Equipment_Account = Account.find(5)
  Rentals_Debit_Account = Account.find(6)
  Food_Account = Account.find(7)
  Payroll_Account = Account.find(8)
  Misc_Debit_Account = Account.find(9)

  def total(start_date=Account.magic_date, end_date=nil)
    if end_date
      Journal.where("date >= ? AND date < ? AND account_id = (?)", start_date, end_date, id.to_s).sum(:amount)
    else
      Journal.where("date >= ? AND account_id = (?)", start_date, id.to_s).sum(:amount)
    end
  end
end
