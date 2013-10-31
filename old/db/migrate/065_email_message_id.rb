class EmailMessageId < ActiveRecord::Migration
  def self.up
    add_column("emails", "message_id", :string, :null => false);
  end

  def self.down
  end
end
