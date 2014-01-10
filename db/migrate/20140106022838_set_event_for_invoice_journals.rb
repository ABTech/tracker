class SetEventForInvoiceJournals < ActiveRecord::Migration
  def up
    Journal.where("invoice_id IS NOT NULL AND event_id IS NULL").each do |journal|
      journal.event = journal.invoice.event
      journal.save!
    end
  end
  
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
