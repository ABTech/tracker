class Nullable < ActiveRecord::Migration
  def self.up
    change_column("accounts", "position", :integer, :null => false);
    change_column("emails", "event_id", :integer, :null => false);
    change_column("equipment", "parent_id", :integer, :null => false);
    change_column("equipment", "description", :string, :null => false);
    change_column("equipment", "position", :integer, :null => false);
    change_column("equipment", "shortname", :string, :null => false);
    change_column("equipment_categories", "name", :string, :null => false);
    change_column("equipment_categories", "parent_id", :integer, :null => false);
    change_column("equipment_categories", "position", :integer, :null => false);
    change_column("event_logs", "event_id", :integer, :null => false);
    change_column("event_logs", "call_participation", :boolean, :null => false);
    change_column("event_logs", "show_participation", :boolean, :null => false);
    change_column("event_logs", "strike_participation", :boolean, :null => false);
    change_column("event_logs", "kerbid", :string, :null => false);
    change_column("event_roles", "event_id", :integer, :null => false);
    change_column("event_roles", "member_id", :integer, :null => false);
    change_column("event_roles", "role", :string, :null => false);
    change_column("eventdates", "event_id", :integer, :null => false);
    change_column("eventdates", "calldate", :datetime, :null => false);
    change_column("eventdates", "strikedate", :datetime, :null => false);
    change_column("eventdates", "description", :string, :null => false);
    change_column("events", "contactemail", :string, :null => false);
    change_column("events", "arb_member_id", :integer, :null => false);
    change_column("events_locations", "location_id", :integer, :null => false);
    change_column("events_locations", "event_id", :integer, :null => false);
    change_column("invoice_lines", "quantity", :integer, :null => false);
    change_column("invoices", "status", :string, :null => false);
    change_column("invoices", "payment_type", :string, :null => false);
    change_column("invoices", "oracle_string", :string, :null => false);
    change_column("journals", "amount", :integer, :null => false);
    change_column("journals", "account_credit_id", :integer, :null => false);
    change_column("journals", "account_debit_id", :integer, :null => false);
    change_column("journals", "link_paid_id", :integer, :null => false);
    change_column("locations", "building", :string, :null => false);
    change_column("locations", "floor", :string, :null => false);
    change_column("locations", "room", :string, :null => false);
    change_column("members", "kerbid", :string, :null => false);
    change_column("members", "namenick", :string, :null => false);
    change_column("members", "phone", :string, :null => false);
    change_column("members", "aim", :string, :null => false);
    change_column("members", "crypted_password", :string, {:null => false, :limit => 40});
    change_column("members", "salt", :string, {:null => false, :limit => 40});
    change_column("members", "remember_token", :string, :null => false);
    change_column("members", "remember_token_expires_at", :datetime, :null => false);
    change_column("pagers", "connectionstr", :string, :null => false);
    change_column("roles", "info", :string, {:null => false, :limit => 80});
    change_column("schema_info", "version", :integer, :null => false);
  end

  def self.down
  end
end
