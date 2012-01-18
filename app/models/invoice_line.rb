# == Schema Information
# Schema version: 93
#
# Table name: invoice_lines
#
#  id         :integer(11)     not null, primary key
#  invoice_id :integer(11)     not null
#  memo       :string(255)     not null
#  category   :string(255)     not null
#  price      :float
#  quantity   :integer(11)     not null
#  notes      :text
#

class InvoiceLine < ActiveRecord::Base
    belongs_to :invoice;

    Invoice_Categories = [  "Sound",
                            "Lighting",
                            "Reimbursement",
                            "Itemized",
			    "Labor",
			    "Event"];

    def total
		if (price and quantity)
			return price * quantity;
		else
			return 0
		end
    end

    validates_presence_of :invoice_id, :price, :quantity, :category, :memo;
    validates_inclusion_of :category, :in => Invoice_Categories;
    validates_inclusion_of :category, :in => Invoice_Categories;
end
