class AddNotesToInvoiceItems < ActiveRecord::Migration[6.1]
  def change
    add_column :invoice_items, :notes, :text
  end
end
