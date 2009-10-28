class ChangeAccountToAccountId < ActiveRecord::Migration
  def self.up
	add_column("journals", "account_id", :integer, :default => 1, :null => false)
	
	Journal.find(:all).each do |foo|
		foo.account_id = foo.account
	end
	
	remove_column("journals", "account")
  end
  
  def self.down
    
  end
end