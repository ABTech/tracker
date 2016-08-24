class RemoveLegacyIndexes < ActiveRecord::Migration[5.0]
  def change
    remove_index :emails, :sender
    remove_index :emails, :subject
    remove_index :emails, :contents
    remove_index :equipment, :description
    remove_index :eventdates, :description
    remove_index :events, :title
    remove_index :invoice_items, :category
    remove_index :members, :namefirst
    remove_index :members, :namelast
    remove_index :organizations, :name
  end
end
