class PolymorphicAttachments < ActiveRecord::Migration
  def up
    add_column :attachments, :attachable_id, :integer
    add_column :attachments, :attachable_type, :string
    
    Attachment.all.each do |a|
      if a.event_id
        a.attachable_id = a.event_id
        a.attachable_type = "Event"
      elsif a.journal_id
        a.attachable_id = a.journal_id
        a.attachable_type = "Journal"
      end
      
      a.save!
    end
    
    remove_column :attachments, :event_id
    remove_column :attachments, :journal_id
  end
  
  def down
    add_column :attachments, :event_id, :integer
    add_column :attachments, :journal_id, :integer
    
    Attachment.all.each do |a|
      if a.attachable_type == "Event"
        a.event_id = a.attachable_id
      elsif a.attachable_type == "Journal"
        a.journal_id = a.attachable_id
      end
      
      a.save!
    end
    
    remove_column :attachments, :attachable_id
    remove_column :attachments, :attachable_type
  end
end
