class CreateInvoiceContacts < ActiveRecord::Migration[6.1]
  def change
    create_table :invoice_contacts do |t|
      t.string :email, null: false
      t.text :notes

      t.timestamps
    end
    add_index :invoice_contacts, :email, unique: true
  end
end
