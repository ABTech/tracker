class InvoiceLine < ActiveRecord::Base
  belongs_to :invoice

  validates_presence_of :invoice_id, :price, :quantity, :category, :memo;
  validates_inclusion_of :category, :in => Invoice_Categories;
  validates_inclusion_of :category, :in => Invoice_Categories;

  Invoice_Categories = [  "Sound",
                          "Lighting",
                          "Reimbursement",
                          "Itemized",
                          "Labor",
                          "Event"]

  def total
    if (price and quantity)
      return price * quantity;
    else
      return 0
    end
  end
end
