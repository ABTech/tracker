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
    Invoice_Categories.find_index(category)
  end

  def <=> (other)
    sort_key <=> other.sort_key
  end
end
