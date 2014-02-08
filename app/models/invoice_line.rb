class InvoiceLine < ActiveRecord::Base
  belongs_to :invoice, :inverse_of => :invoice_lines

  Invoice_Categories = [  "Sound",
                          "Lighting",
                          "Reimbursement",
                          "Itemized",
                          "Labor",
                          "Event"]

  validates_presence_of :invoice, :price, :quantity, :category, :memo
  validates_inclusion_of :category, :in => Invoice_Categories

  def total
    if (price and quantity)
      return price * quantity;
    else
      return 0
    end
  end
end
