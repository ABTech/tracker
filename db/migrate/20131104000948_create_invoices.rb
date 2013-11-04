class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.references :event, index: true
      t.string :status
      t.boolean :recognized
      t.string :payment_type
      t.string :oracle_string
      t.text :memo

      t.timestamps
    end
  end
end
