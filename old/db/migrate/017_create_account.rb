class CreateAccount < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.column "name", :string, :null => false;
      t.column "type", :string, :null => false;
      t.column "parent_id", :integer, :null => false;
      t.column "order", :integer, :null => false;
    end
    add_index("accounts", "parent_id");

    create_table :journals do |t|
      t.column "created_at", :datetime;
      t.column "date", :datetime, :null => false;
      t.column "memo", :string, :null => false;
      t.column "type", :string, :null => false;
      t.column "link_id", :integer, :null => false;
    end;
    add_index("journals", "link_id");
    create_table :journal_lines do |t|
      t.column "journal_id", :integer, :null => false;
      t.column "account_id", :integer, :null => false;
      t.column "credit", :integer, :null => false;
      t.column "debit", :integer, :null => false;
    end;
    add_index("journal_lines", "journal_id");
    add_index("journal_lines", "account_id");
  end

  def self.down
    drop_table :accounts;
    drop_table :journals;
    drop_table :journal_lines;
  end
end
