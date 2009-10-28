class FixAccounts < ActiveRecord::Migration
  def self.up
	drop_table :accounts
	create_table :accounts do |t|
      t.column "name", :string, :null => false;
      t.column "is_credit", :boolean, :null => false;
      t.column "position", :integer, :null => false;
    end

	Account.new(:name => "Events", :is_credit => true, :position => 1).save();
	Account.new(:name => "Rentals", :is_credit => true, :position => 2).save();
	Account.new(:name => "CMU", :is_credit => true, :position => 3).save();
	Account.new(:name => "Misc", :is_credit => true, :position => 4).save();
	
	Account.new(:name => "Equipment", :is_credit => false, :position => 5).save()
	Account.new(:name => "Rentals", :is_credit => false, :position => 6).save();
	Account.new(:name => "Food", :is_credit => false, :position => 7).save();
	Account.new(:name => "Payroll", :is_credit => false, :position => 8).save();
	Account.new(:name => "Misc", :is_credit => false, :position => 9).save();
  end
  
  def self.down
    
  end
end