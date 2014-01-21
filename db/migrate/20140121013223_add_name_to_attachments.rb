class AddNameToAttachments < ActiveRecord::Migration
  def up
    Attachment.all.each do |a|
      a.update_column(:name, a.attachment_file_name)
    end
    
    change_column :attachments, :name, :string, :null => false
  end
  
  def down
    change_column :attachments, :name, :string, :null => true
    
    Attachment.all.each do |a|
      a.update_column(:name, nil)
    end
  end
end
