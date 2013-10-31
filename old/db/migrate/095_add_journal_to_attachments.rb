class AddJournalToAttachments < ActiveRecord::Migration
  def self.up
    add_column :attachments, :journal_id, :integer
  end

  def self.down
    remove_column :attachments, :journal_id
  end
end
