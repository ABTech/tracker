# == Schema Information
#
# Table name: invoice_items
#
#  id                 :integer          not null, primary key
#  memo               :string(255)      not null
#  category           :string(255)      not null
#  price_recognized   :integer          not null
#  price_unrecognized :integer          not null
#

class InvoiceItem < ActiveRecord::Base
    validates_presence_of :memo, :category, :price_recognized, :price_unrecognized;
    validates_inclusion_of :category, :in => InvoiceLine::Invoice_Categories;
end
