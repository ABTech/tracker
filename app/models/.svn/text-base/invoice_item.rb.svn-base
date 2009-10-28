# == Schema Information
# Schema version: 78
#
# Table name: invoice_items
#
#  id                 :integer(11)     not null, primary key
#  memo               :string(255)     default(""), not null
#  category           :string(255)     default(""), not null
#  price_recognized   :integer(11)     not null
#  price_unrecognized :integer(11)     not null
#

class InvoiceItem < ActiveRecord::Base
    validates_presence_of :memo, :category, :price_recognized, :price_unrecognized;
    validates_inclusion_of :category, :in => InvoiceLine::Invoice_Categories;
end
