class InvoiceLine < ApplicationRecord
  belongs_to :invoice, :inverse_of => :invoice_lines

  Invoice_Categories = [  "Sound",
                          "Lighting",
                          "Media",
                          "Reimbursement",
                          "Itemized",
                          "Labor",
                          "Event"]

  validates_presence_of :invoice, :price, :quantity, :category, :memo
  validates_inclusion_of :category, :in => Invoice_Categories

  def total
    price * quantity
  end

  def sort_key
    index = Invoice_Categories.find_index(category)
    index.nil? ? -1 : index  # Replace nil with -1 if not found
  end

  def <=> (other)
    sort_key <=> other.sort_key
  end
end
