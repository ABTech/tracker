class Journals < ActiveRecord::Migration
  def self.up
    add_column("journals", "amount", :integer);
    add_column("journals", "account_credit_id", :integer);
    add_column("journals", "account_debit_id", :integer);
    drop_table("journal_lines");
  end

  def self.down
  end
end
