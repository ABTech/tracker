class RemoveUnrecognizedPricing < ActiveRecord::Migration
  def change
    rename_column :invoice_items, :price_recognized, :price
    remove_column :invoice_items, :price_unrecognized, :integer, null: false
    remove_column :invoices, :recognized, null: false
  end
end
