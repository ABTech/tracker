class CreateAttachments < ActiveRecord::Migration
  def self.up
    create_table :attachments do |t|
      t.column :name, :string
      t.column :attachment_file_name, :string
      t.column :attachment_content_type, :string
      t.column :attachment_file_size, :integer
      t.column :attachment_updated_at, :datetime
      t.column :event_id, :integer

      t.column :updated_at, :datetime
      t.column :created_at, :datetime
    end
  end

  def self.down
    drop_table :attachments
  end
end
