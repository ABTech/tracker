class ConvertTablesToRealUnicode < ActiveRecord::Migration[5.0]
  def up
    execute "UPDATE eventdates SET calldate = NULL WHERE CAST(calldate AS CHAR(20)) = '0000-00-00 00:00:00'"
    
    change_column :attachments, :attachable_type, :string, limit: 191
    change_column :event_roles, :role, :string, limit: 191, null: false
    change_column :event_roles, :roleable_type, :string, limit: 191, null: false
    change_column :events, :contactemail, :string, limit: 191
    change_column :events, :status, :string, limit: 191, null: false, default: "Initial Request"
    change_column :members, :email, :string, limit: 191, null: false
    
    execute "ALTER DATABASE " + ActiveRecord::Base.connection.current_database + " CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;"
    
    models = [Account, Attachment, Blackout, Comment, EmailForm, Email, Equipment, EventRoleApplication, EventRole, Event, Eventdate, InvoiceItem, InvoiceLine, Invoice, Journal, Location, Member, Organization, SuperTic, TimecardEntry, Timecard]
    models.each do |m|
      tn = m.table_name
      execute "ALTER TABLE " + tn + " CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;"
      
      m.columns.each do |c|
        if /(text|varchar\([0-9]+\))/.match(c.sql_type)
          constraints = ""
          if !c.null
            constraints += " NOT NULL"
          end
          if !c.default.nil?
            constraints += " DEFAULT '" + c.default + "'"
          end
          execute "ALTER TABLE " + tn + " MODIFY " + c.name + " " + c.sql_type + " CHARACTER SET utf8mb4 COLLATE utf8mb4_bin"  + constraints + ";"
        end
      end
    end
    
    execute "ALTER TABLE schema_migrations CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;"
    execute "ALTER TABLE schema_migrations MODIFY version varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;"
    
    execute "ALTER TABLE ar_internal_metadata CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;"
    execute "ALTER TABLE ar_internal_metadata MODIFY `key` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;"
    execute "ALTER TABLE ar_internal_metadata MODIFY value varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;"
    
    execute "ALTER TABLE equipment_eventdates CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;"
    execute "ALTER TABLE eventdates_locations CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;"
    
    ["accounts", "ar_internal_metadata", "attachments", "blackouts", "comments", "email_forms", "emails", "equipment", "equipment_eventdates", "event_role_applications", "event_roles", "eventdates", "eventdates_locations", "events", "invoice_items", "invoice_lines", "invoices", "journals", "locations", "members", "organizations", "schema_migrations", "super_tics", "timecard_entries", "timecards"].each do |table|
      execute "REPAIR TABLE " + table + ";"
      execute "OPTIMIZE TABLE " + table + ";"
    end
  end
  
  def down
    execute "ALTER DATABASE " + ActiveRecord::Base.connection.current_database + " CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
    
    models = [Account, Attachment, Blackout, Comment, EmailForm, Email, Equipment, EventRoleApplication, EventRole, Event, Eventdate, InvoiceItem, InvoiceLine, Invoice, Journal, Location, Member, Organization, SuperTic, TimecardEntry, Timecard]
    models.each do |m|
      tn = m.table_name
      execute "ALTER TABLE " + tn + " CONVERT TO CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
      
      m.columns.each do |c|
        if /(text|varchar\([0-9]+\))/.match(c.sql_type)
          constraints = ""
          if !c.null
            constraints += " NOT NULL"
          end
          if !c.default.nil?
            constraints += " DEFAULT '" + c.default + "'"
          end
          execute "ALTER TABLE " + tn + " MODIFY " + c.name + " " + c.sql_type + " CHARACTER SET utf8 COLLATE utf8_unicode_ci" + constraints + ";"
        end
      end
    end
    
    execute "ALTER TABLE schema_migrations CONVERT TO CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
    execute "ALTER TABLE schema_migrations MODIFY version varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
    
    execute "ALTER TABLE ar_internal_metadata CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;"
    execute "ALTER TABLE ar_internal_metadata MODIFY `key` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci;"
    execute "ALTER TABLE ar_internal_metadata MODIFY value varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci;"
    
    execute "ALTER TABLE equipment_eventdates CONVERT TO CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
    execute "ALTER TABLE eventdates_locations CONVERT TO CHARACTER SET latin1 COLLATE latin1_swedish_ci;"
    
    change_column :attachments, :attachable_type, :string, limit: 255
    change_column :event_roles, :role, :string, limit: 255, null: false
    change_column :event_roles, :roleable_type, :string, limit: 255, null: false
    change_column :events, :contactemail, :string, limit: 255
    change_column :events, :status, :string, limit: 255, null: false, default: "Initial Request"
    change_column :members, :email, :string, limit: 255, null: false
    
    ["accounts", "ar_internal_metadata", "attachments", "blackouts", "comments", "email_forms", "emails", "equipment", "equipment_eventdates", "event_role_applications", "event_roles", "eventdates", "eventdates_locations", "events", "invoice_items", "invoice_lines", "invoices", "journals", "locations", "members", "organizations", "schema_migrations", "super_tics", "timecard_entries", "timecards"].each do |table|
      execute "REPAIR TABLE " + table + ";"
      execute "OPTIMIZE TABLE " + table + ";"
    end
  end
end
