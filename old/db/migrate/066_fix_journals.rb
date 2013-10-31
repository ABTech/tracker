class FixJournals < ActiveRecord::Migration
  def self.up
	# defaults are sufficient- all current JEs are for events
	add_column("journals", "account", :integer, :default => 1, :null => false)
	add_column("journals", "date_paid", :datetime)
	add_column("journals", "notes", :text)
	
	change_column("journals", "amount", :decimal, :precision => 9, :scale => 2, :null => false, :default => 0.0);
	change_column("journals", "link_id", :integer, :default => nil, :null => true); # not everything is tied to an invoice now
	
	Journal.find(:all).each do |foo|
        if (foo.link_paid_id > 0)
			foo.date_paid = Journal.find(foo.link_paid_id).date
			if (!foo.save())
				foo.errors.each_full() do |err|
					raise err
				end
			end
		end
    end
	
	Journal.find(:all, :conditions => { :account_debit_id => 3 }).each do |foo|
		foo.destroy() # get rid of JeInvPaid JEs because they're redundant
	end
	
	remove_column("journals", "type")
	remove_column("journals", "account_credit_id")
	remove_column("journals", "account_debit_id")
	remove_column("journals", "link_paid_id")
  end
  
  def self.down
    
  end
end