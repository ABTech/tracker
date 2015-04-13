class SetTextFieldsToNotNull < ActiveRecord::Migration
  def up
    execute "UPDATE comments SET content = \"\" WHERE content IS NULL;"
    execute "UPDATE email_forms SET contents = \"\" WHERE contents IS NULL;"
    execute "UPDATE emails SET headers = \"\" WHERE headers IS NULL;"
    execute "UPDATE eventdates SET email_description = \"\" WHERE email_description IS NULL;"
    execute "UPDATE eventdates SET notes = \"\" WHERE notes IS NULL;"
    execute "UPDATE invoice_lines SET notes = \"\" WHERE notes IS NULL;"
    execute "UPDATE invoices SET memo = \"\" WHERE memo IS NULL;"
    execute "UPDATE journals SET notes = \"\" WHERE notes IS NULL;"
    execute "UPDATE locations SET details = \"\" WHERE details IS NULL;"
    
    change_column :comments, :content, :text, :null => false
    change_column :email_forms, :contents, :text, :null => false
    change_column :emails, :headers, :text, :null => false
    change_column :eventdates, :email_description, :text, :null => false
    change_column :eventdates, :notes, :text, :null => false
    change_column :invoice_lines, :notes, :text, :null => false
    change_column :invoices, :memo, :text, :null => false
    change_column :journals, :notes, :text, :null => false
    change_column :locations, :details, :text, :null => false
  end
  
  def down
    change_column :comments, :content, :text
    change_column :email_forms, :contents, :text
    change_column :emails, :headers, :text
    change_column :eventdates, :email_description, :text
    change_column :eventdates, :notes, :text
    change_column :invoice_lines, :notes, :text
    change_column :invoices, :memo, :text
    change_column :journals, :notes, :text
    change_column :locations, :details, :text
  end
end
