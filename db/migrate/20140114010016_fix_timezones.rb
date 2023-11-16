class FixTimezones < ActiveRecord::Migration
  def up
    CurrentAcademicYear.all.each do |account|
      account.update_column(:created_at, account.created_at - account.created_at.utc_offset) if account.created_at
      account.update_column(:updated_at, account.updated_at - account.updated_at.utc_offset) if account.updated_at
    end
    
    Attachment.all.each do |a|
      a.update_column(:attachment_updated_at, a.attachment_updated_at - a.attachment_updated_at.utc_offset) if a.attachment_updated_at
      a.update_column(:created_at, a.created_at - a.created_at.utc_offset) if a.created_at
      a.update_column(:updated_at, a.updated_at - a.updated_at.utc_offset) if a.updated_at
    end
    
    Comment.all.each do |comment|
      comment.update_column(:created_at, comment.created_at - comment.created_at.utc_offset)
      comment.update_column(:updated_at, comment.updated_at - comment.updated_at.utc_offset) if comment.updated_at
    end
    
    EmailForm.all.each do |ef|
      ef.update_column(:created_at, ef.created_at - ef.created_at.utc_offset) if ef.created_at
      ef.update_column(:updated_at, ef.updated_at - ef.updated_at.utc_offset) if ef.updated_at
    end
    
    Email.all.each do |email|
      email.update_column(:timestamp, email.timestamp - email.timestamp.utc_offset)
      email.update_column(:created_at, email.created_at - email.created_at.utc_offset) if email.created_at
      email.update_column(:updated_at, email.updated_at - email.updated_at.utc_offset) if email.updated_at
    end
    
    Equipment.all.each do |eq|
      eq.update_column(:created_at, eq.created_at - eq.created_at.utc_offset) if eq.created_at
      eq.update_column(:updated_at, eq.updated_at - eq.updated_at.utc_offset) if eq.updated_at
    end
    
    EquipmentCategory.all.each do |eq|
      eq.update_column(:created_at, eq.created_at - eq.created_at.utc_offset) if eq.created_at
      eq.update_column(:updated_at, eq.updated_at - eq.updated_at.utc_offset) if eq.updated_at
    end
    
    EventRole.all.each do |er|
      er.update_column(:created_at, er.created_at - er.created_at.utc_offset) if er.created_at
      er.update_column(:updated_at, er.updated_at - er.updated_at.utc_offset) if er.updated_at
    end
    
    Eventdate.all.each do |ed|
      ed.update_column(:startdate, ed.startdate - ed.startdate.utc_offset)
      ed.update_column(:enddate, ed.enddate - ed.enddate.utc_offset)
      ed.update_column(:calldate, ed.calldate - ed.calldate.utc_offset) if ed.calldate
      ed.update_column(:strikedate, ed.strikedate - ed.strikedate.utc_offset) if ed.strikedate
      ed.update_column(:created_at, ed.created_at - ed.created_at.utc_offset) if ed.created_at
      ed.update_column(:updated_at, ed.updated_at - ed.updated_at.utc_offset) if ed.updated_at
    end
    
    Event.all.each do |event|
      event.update_column(:representative_date, event.representative_date - event.representative_date.utc_offset)
      event.update_column(:created_at, event.created_at - event.created_at.utc_offset) if event.created_at
      event.update_column(:updated_at, event.updated_at - event.updated_at.utc_offset) if event.updated_at
    end
    
    InvoiceItem.all.each do |ii|
      ii.update_column(:created_at, ii.created_at - ii.created_at.utc_offset) if ii.created_at
      ii.update_column(:updated_at, ii.updated_at - ii.updated_at.utc_offset) if ii.updated_at
    end
    
    InvoiceLine.all.each do |il|
      il.update_column(:created_at, il.created_at - il.created_at.utc_offset) if il.created_at
      il.update_column(:updated_at, il.updated_at - il.updated_at.utc_offset) if il.updated_at
    end
    
    Invoice.all.each do |invoice|
      invoice.update_column(:created_at, invoice.created_at - invoice.created_at.utc_offset) if invoice.created_at
      invoice.update_column(:updated_at, invoice.updated_at - invoice.updated_at.utc_offset) if invoice.updated_at
    end
    
    Journal.all.each do |journal|
      journal.update_column(:date, journal.date - journal.date.utc_offset)
      journal.update_column(:date_paid, journal.date_paid - journal.date_paid.utc_offset) if journal.date_paid
      journal.update_column(:created_at, journal.created_at - journal.created_at.utc_offset) if journal.created_at
      journal.update_column(:updated_at, journal.updated_at - journal.updated_at.utc_offset) if journal.updated_at
    end
    
    Location.all.each do |location|
      location.update_column(:created_at, location.created_at - location.created_at.utc_offset) if location.created_at
      location.update_column(:updated_at, location.updated_at - location.updated_at.utc_offset) if location.updated_at
    end
    
    Member.all.each do |member|
      member.update_column(:created_at, member.created_at - member.created_at.utc_offset) if member.created_at
      member.update_column(:updated_at, member.updated_at - member.updated_at.utc_offset) if member.updated_at
      member.update_column(:remember_token_expires_at, member.remember_token_expires_at - member.remember_token_expires_at.utc_offset) if member.remember_token_expires_at
    end
    
    Organization.all.each do |org|
      org.update_column(:created_at, org.created_at - org.created_at.utc_offset) if org.created_at
      org.update_column(:updated_at, org.updated_at - org.updated_at.utc_offset) if org.updated_at
    end
    
    Permission.all.each do |p|
      p.update_column(:created_at, p.created_at - p.created_at.utc_offset) if p.created_at
      p.update_column(:updated_at, p.updated_at - p.updated_at.utc_offset) if p.updated_at
    end
    
    Role.all.each do |r|
      r.update_column(:created_at, r.created_at - r.created_at.utc_offset) if r.created_at
      r.update_column(:updated_at, r.updated_at - r.updated_at.utc_offset) if r.updated_at
    end
    
    TimecardEntry.all.each do |te|
      te.update_column(:created_at, te.created_at - te.created_at.utc_offset) if te.created_at
      te.update_column(:updated_at, te.updated_at - te.updated_at.utc_offset) if te.updated_at
    end
    
    Timecard.all.each do |timecard|
      timecard.update_column(:billing_date, timecard.billing_date - timecard.billing_date.utc_offset)
      timecard.update_column(:due_date, timecard.due_date - timecard.due_date.utc_offset)
      timecard.update_column(:start_date, timecard.start_date - timecard.start_date.utc_offset)
      timecard.update_column(:end_date, timecard.end_date - timecard.end_date.utc_offset)
      timecard.update_column(:created_at, timecard.created_at - timecard.created_at.utc_offset) if timecard.created_at
      timecard.update_column(:updated_at, timecard.updated_at - timecard.updated_at.utc_offset) if timecard.updated_at
    end
  end
  
  def down
    CurrentAcademicYear.all.each do |account|
      account.update_column(:created_at, account.created_at + account.created_at.utc_offset) if account.created_at
      account.update_column(:updated_at, account.updated_at + account.updated_at.utc_offset) if account.updated_at
    end
    
    Attachment.all.each do |a|
      a.update_column(:attachment_updated_at, a.attachment_updated_at + a.attachment_updated_at.utc_offset) if a.attachment_updated_at
      a.update_column(:created_at, a.created_at + a.created_at.utc_offset) if a.created_at
      a.update_column(:updated_at, a.updated_at + a.updated_at.utc_offset) if a.updated_at
    end
    
    Comment.all.each do |comment|
      comment.update_column(:created_at, comment.created_at + comment.created_at.utc_offset)
      comment.update_column(:updated_at, comment.updated_at + comment.updated_at.utc_offset) if comment.updated_at
    end
    
    EmailForm.all.each do |ef|
      ef.update_column(:created_at, ef.created_at + ef.created_at.utc_offset) if ef.created_at
      ef.update_column(:updated_at, ef.updated_at + ef.updated_at.utc_offset) if ef.updated_at
    end
    
    Email.all.each do |email|
      email.update_column(:timestamp, email.timestamp + email.timestamp.utc_offset)
      email.update_column(:created_at, email.created_at + email.created_at.utc_offset) if email.created_at
      email.update_column(:updated_at, email.updated_at + email.updated_at.utc_offset) if email.updated_at
    end
    
    Equipment.all.each do |eq|
      eq.update_column(:created_at, eq.created_at + eq.created_at.utc_offset) if eq.created_at
      eq.update_column(:updated_at, eq.updated_at + eq.updated_at.utc_offset) if eq.updated_at
    end
    
    EquipmentCategory.all.each do |eq|
      eq.update_column(:created_at, eq.created_at + eq.created_at.utc_offset) if eq.created_at
      eq.update_column(:updated_at, eq.updated_at + eq.updated_at.utc_offset) if eq.updated_at
    end
    
    EventRole.all.each do |er|
      er.update_column(:created_at, er.created_at + er.created_at.utc_offset) if er.created_at
      er.update_column(:updated_at, er.updated_at + er.updated_at.utc_offset) if er.updated_at
    end
    
    Eventdate.all.each do |ed|
      ed.update_column(:startdate, ed.startdate + ed.startdate.utc_offset)
      ed.update_column(:enddate, ed.enddate + ed.enddate.utc_offset)
      ed.update_column(:calldate, ed.calldate + ed.calldate.utc_offset) if ed.calldate
      ed.update_column(:strikedate, ed.strikedate + ed.strikedate.utc_offset) if ed.strikedate
      ed.update_column(:created_at, ed.created_at + ed.created_at.utc_offset) if ed.created_at
      ed.update_column(:updated_at, ed.updated_at + ed.updated_at.utc_offset) if ed.updated_at
    end
    
    Event.all.each do |event|
      event.update_column(:representative_date, event.representative_date + event.representative_date.utc_offset)
      event.update_column(:created_at, event.created_at + event.created_at.utc_offset) if event.created_at
      event.update_column(:updated_at, event.updated_at + event.updated_at.utc_offset) if event.updated_at
    end
    
    InvoiceItem.all.each do |ii|
      ii.update_column(:created_at, ii.created_at + ii.created_at.utc_offset) if ii.created_at
      ii.update_column(:updated_at, ii.updated_at + ii.updated_at.utc_offset) if ii.updated_at
    end
    
    InvoiceLine.all.each do |il|
      il.update_column(:created_at, il.created_at + il.created_at.utc_offset) if il.created_at
      il.update_column(:updated_at, il.updated_at + il.updated_at.utc_offset) if il.updated_at
    end
    
    Invoice.all.each do |invoice|
      invoice.update_column(:created_at, invoice.created_at + invoice.created_at.utc_offset) if invoice.created_at
      invoice.update_column(:updated_at, invoice.updated_at + invoice.updated_at.utc_offset) if invoice.updated_at
    end
    
    Journal.all.each do |journal|
      journal.update_column(:date, journal.date + journal.date.utc_offset)
      journal.update_column(:date_paid, journal.date_paid + journal.date_paid.utc_offset) if journal.date_paid
      journal.update_column(:created_at, journal.created_at + journal.created_at.utc_offset) if journal.created_at
      journal.update_column(:updated_at, journal.updated_at + journal.updated_at.utc_offset) if journal.updated_at
    end
    
    Location.all.each do |location|
      location.update_column(:created_at, location.created_at + location.created_at.utc_offset) if location.created_at
      location.update_column(:updated_at, location.updated_at + location.updated_at.utc_offset) if location.updated_at
    end
    
    Member.all.each do |member|
      member.update_column(:created_at, member.created_at + member.created_at.utc_offset) if member.created_at
      member.update_column(:updated_at, member.updated_at + member.updated_at.utc_offset) if member.updated_at
      member.update_column(:remember_token_expires_at, member.remember_token_expires_at + member.remember_token_expires_at.utc_offset) if member.remember_token_expires_at
    end
    
    Organization.all.each do |org|
      org.update_column(:created_at, org.created_at + org.created_at.utc_offset) if org.created_at
      org.update_column(:updated_at, org.updated_at + org.updated_at.utc_offset) if org.updated_at
    end
    
    Permission.all.each do |p|
      p.update_column(:created_at, p.created_at + p.created_at.utc_offset) if p.created_at
      p.update_column(:updated_at, p.updated_at + p.updated_at.utc_offset) if p.updated_at
    end
    
    Role.all.each do |r|
      r.update_column(:created_at, r.created_at + r.created_at.utc_offset) if r.created_at
      r.update_column(:updated_at, r.updated_at + r.updated_at.utc_offset) if r.updated_at
    end
    
    TimecardEntry.all.each do |te|
      te.update_column(:created_at, te.created_at + te.created_at.utc_offset) if te.created_at
      te.update_column(:updated_at, te.updated_at + te.updated_at.utc_offset) if te.updated_at
    end
    
    Timecard.all.each do |timecard|
      timecard.update_column(:billing_date, timecard.billing_date + timecard.billing_date.utc_offset)
      timecard.update_column(:due_date, timecard.due_date + timecard.due_date.utc_offset)
      timecard.update_column(:start_date, timecard.start_date + timecard.start_date.utc_offset)
      timecard.update_column(:end_date, timecard.end_date + timecard.end_date.utc_offset)
      timecard.update_column(:created_at, timecard.created_at + timecard.created_at.utc_offset) if timecard.created_at
      timecard.update_column(:updated_at, timecard.updated_at + timecard.updated_at.utc_offset) if timecard.updated_at
    end
  end
end
