class Account < ActiveRecord::Base
  has_many :journals, -> { order "journals.date DESC" }
    
  validates_presence_of :name, :position;
  validates_inclusion_of :is_credit, :in => [true, false];

  # When you change this magic date, finances are reset. JEs before this date don't count. Perhaps this should be made sensible some day.
  Magic_Date = '2013-07-01'
  Future_Magic_Date = '2014-07-01'
  		
  # Credit
  Credit_Accounts = Account.find(:all, :conditions => "is_credit = true")
  Events_Account = Account.find(1);
  Rentals_Credit_Account = Account.find(2);
  CMU_Account = Account.find(3);
  Misc_Credit_Account = Account.find(4);

  # Debit
  Debit_Accounts = Account.find(:all, :conditions => "is_credit = false")
  Equipment_Account = Account.find(5);
  Rentals_Debit_Account = Account.find(6);
  Food_Account = Account.find(7);
  Payroll_Account = Account.find(8);
  Misc_Debit_Account = Account.find(9);

  def total(start_date=Account::Magic_Date, end_date=nil)
    if end_date
      t = Journal.sum(:amount, :conditions => ["date >= '" + start_date + "' AND date < '"+ end_date +"' AND account_id = (?)", id.to_s]);
    else
      t = Journal.sum(:amount, :conditions => ["date >= '" + start_date + "' AND account_id = (?)", id.to_s]);
    end

    return (t == nil ? 0 : t)
  end
end
