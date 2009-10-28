class LogsAsString < ActiveRecord::Migration
  def self.up
    remove_column("event_logs", "member_id");
    add_column("event_logs", "kerbid", :string);
  end

  def self.down
  end
end
