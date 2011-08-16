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

class Account < ActiveRecord::Base
    has_many :journals, :class_name => "Journal", :foreign_key => "account", :order => "journals.date DESC";
    
  #When you change this magic date, finances are reset. JEs before this date don't count. Perhaps this should be made sensible some day.
	Magic_Date = '2011-08-01'
  		
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
    
	def total
        t = Journal.sum(:amount, :conditions => ["date > '" + Account::Magic_Date + "' AND account_id = (?)", id.to_s]);
		return (t == nil ? 0 : t)
    end
	
	def total_s
		return "$%01.2f" % total
	end
    
    #def unpaid_payable
    #    return journals_credit.find(:all, :conditions => ["IFNULL(link_paid_id, 0) = 0 AND date > '2007-05-31'"]);
    #end

    #def unpaid_receivable
    #    return journals_debit.find(:all, :conditions => ["IFNULL(link_paid_id, 0) = 0 AND date > '2007-05-31'"]);
    #end

    # def tree_as_collection(indent=0)
        # list = [];

        # children.sort_by {|i| i.position}.each do |child|
            # if(child.class == AccGroup)
                # list << [("-"*indent + child.name + " (GROUP)"), child.id];
                # list = list.concat(child.tree_as_collection(indent+1));
            # else
                # list << [("-"*indent + child.name), child.id];
            # end
        # end

        # return list;
    # end

    validates_presence_of :name, :position;
	validates_inclusion_of :is_credit, :in => [true, false];
end
