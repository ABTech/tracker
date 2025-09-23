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

  def <=> (il)
    return 1 if Invoice_Categories.find_index(category).nil?
    return -1 if Invoice_Categories.find_index(il.category).nil?
    return Invoice_Categories.find_index(category) <=> Invoice_Categories.find_index(il.category)
  end

  def get_notes_with_defaults
    if not self.notes.empty?
      self.notes
    else
      if category == "Labor"
        "Labor hours are estimates; Actual hours will be billed."
      end
    end
  end
end
