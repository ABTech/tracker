# == Schema Information
# Schema version: 93
#
# Table name: invoice_items
#
#  id                 :integer(11)     not null, primary key
#  memo               :string(255)     not null
#  category           :string(255)     not null
#  price_recognized   :integer(11)     not null
#  price_unrecognized :integer(11)     not null
#

class InvoiceItems < ActiveRecord::Base
end
