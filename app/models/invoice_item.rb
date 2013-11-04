class InvoiceItem < ActiveRecord::Base
  validates_presence_of :memo, :category, :price_recognized, :price_unrecognized;
  validates_inclusion_of :category, :in => InvoiceLine::Invoice_Categories;
end
