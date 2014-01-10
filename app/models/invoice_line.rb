class InvoiceLine < ActiveRecord::Base
  belongs_to :invoice

  Invoice_Categories = [  "Sound",
                          "Lighting",
                          "Reimbursement",
                          "Itemized",
                          "Labor",
                          "Event"]

  validates_presence_of :invoice_id, :price, :quantity, :category, :memo;
  validates_inclusion_of :category, :in => Invoice_Categories;
  validates_inclusion_of :category, :in => Invoice_Categories;

  attr_accessible :id, :invoice_id, :memo, :category, :price, :quantity, :notes

  def total
    if (price and quantity)
      return price * quantity;
    else
      return 0
    end
  end
end
