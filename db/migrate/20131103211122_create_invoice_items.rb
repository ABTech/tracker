class CreateInvoiceItems < ActiveRecord::Migration
  def change
    create_table :invoice_items do |t|
      t.string :memo
      t.string :category
      t.integer :price_recognized
      t.integer :price_unrecognized

      t.timestamps
    end
  end
end
