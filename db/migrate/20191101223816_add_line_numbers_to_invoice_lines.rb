class AddLineNumbersToInvoiceLines < ActiveRecord::Migration[5.0]
  def change
    add_column :invoice_lines, :line_no, :integer
  end
end
