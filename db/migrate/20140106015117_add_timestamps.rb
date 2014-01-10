class AddTimestamps < ActiveRecord::Migration
  def change
    add_column :accounts, :created_at, :datetime
    add_column :accounts, :updated_at, :datetime
    add_column :email_forms, :created_at, :datetime
    add_column :email_forms, :updated_at, :datetime
    add_column :emails, :created_at, :datetime
    add_column :emails, :updated_at, :datetime
    add_column :equipment, :created_at, :datetime
    add_column :equipment, :updated_at, :datetime
    add_column :equipment_categories, :created_at, :datetime
    add_column :equipment_categories, :updated_at, :datetime
    add_column :event_roles, :created_at, :datetime
    add_column :event_roles, :updated_at, :datetime
    add_column :eventdates, :created_at, :datetime
    add_column :eventdates, :updated_at, :datetime
    add_column :events, :created_at, :datetime
    rename_column :events, :updated_on, :updated_at
    add_column :invoice_items, :created_at, :datetime
    add_column :invoice_items, :updated_at, :datetime
    add_column :invoice_lines, :created_at, :datetime
    add_column :invoice_lines, :updated_at, :datetime
    add_column :invoices, :updated_at, :datetime
    add_column :journals, :updated_at, :datetime
    add_column :locations, :created_at, :datetime
    add_column :locations, :updated_at, :datetime
    add_column :organizations, :created_at, :datetime
    add_column :organizations, :updated_at, :datetime
    add_column :permissions, :created_at, :datetime
    add_column :permissions, :updated_at, :datetime
    add_column :roles, :created_at, :datetime
    add_column :roles, :updated_at, :datetime
    add_column :timecard_entries, :created_at, :datetime
    add_column :timecard_entries, :updated_at, :datetime
    add_column :timecards, :created_at, :datetime
    add_column :timecards, :updated_at, :datetime
  end
end
