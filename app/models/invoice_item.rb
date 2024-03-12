class InvoiceItem < ApplicationRecord
  validates_presence_of :memo, :category, :price, :corporate
  validates_inclusion_of :category, :in => InvoiceLine::Invoice_Categories
  validates_numericality_of :price, :corporate
end
