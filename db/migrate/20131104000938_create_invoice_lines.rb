class CreateInvoiceLines < ActiveRecord::Migration
  def change
    create_table :invoice_lines do |t|
      t.references :invoice, index: true
      t.string :memo
      t.string :category
      t.float :price
      t.integer :quantity
      t.text :notes

      t.timestamps
    end
  end
end
