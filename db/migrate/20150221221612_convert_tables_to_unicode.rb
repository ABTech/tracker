class ConvertTablesToUnicode < ActiveRecord::Migration
  def up
    execute "ALTER DATABASE " + ActiveRecord::Base.connection.current_database + " CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
    
    models = [CurrentAcademicYear, Attachment, Blackout, Comment, EmailForm, Email, EquipmentCategory, EquipmentEventdate, Equipment, EventRole, Event, Eventdate, InvoiceItem, InvoiceLine, Invoice, Journal, Location, Member, Organization, TimecardEntry, Timecard]
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
          execute "ALTER TABLE " + tn + " MODIFY " + c.name + " " + c.sql_type + " CHARACTER SET utf8 COLLATE utf8_unicode_ci"  + constraints + ";"
        end
      end
    end
    
    execute "ALTER TABLE schema_migrations CONVERT TO CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
    execute "ALTER TABLE schema_migrations MODIFY version varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
  end
  
  def down
    execute "ALTER DATABASE " + ActiveRecord::Base.connection.current_database + " CHARACTER SET latin1 COLLATE latin1_swedish_ci;"
    
    models = [CurrentAcademicYear, Attachment, Blackout, Comment, EmailForm, Email, EquipmentCategory, EquipmentEventdate, Equipment, EventRole, Event, Eventdate, InvoiceItem, InvoiceLine, Invoice, Journal, Location, Member, Organization, TimecardEntry, Timecard]
    models.each do |m|
      tn = m.table_name
      execute "ALTER TABLE " + tn + " CONVERT TO CHARACTER SET latin1 COLLATE latin1_swedish_ci;"
      
      m.columns.each do |c|
        if /(text|varchar\([0-9]+\))/.match(c.sql_type)
          constraints = ""
          if !c.null
            constraints += " NOT NULL"
          end
          if !c.default.nil?
            constraints += " DEFAULT '" + c.default + "'"
          end
          execute "ALTER TABLE " + tn + " MODIFY " + c.name + " " + c.sql_type + " CHARACTER SET latin1 COLLATE latin1_swedish_ci" + constraints + ";"
        end
      end
    end
    
    execute "ALTER TABLE schema_migrations CONVERT TO CHARACTER SET latin1 COLLATE latin1_swedish_ci;"
    execute "ALTER TABLE schema_migrations MODIFY version varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci;"
  end
end
