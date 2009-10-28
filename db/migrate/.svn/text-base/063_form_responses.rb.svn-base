class FormResponses < ActiveRecord::Migration
  def self.up
    create_table("email_forms") {};
    add_column("email_forms", "description", :string, :null => false);
    add_column("email_forms", "contents", :text, :null => false);
  end

  def self.down
  end
end
