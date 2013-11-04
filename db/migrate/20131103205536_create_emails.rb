class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.references :event, index: true
      t.string :sender
      t.datetime :timestamp
      t.text :contents
      t.string :status
      t.string :subject
      t.string :message_id

      t.timestamps
    end
  end
end
