# == Schema Information
# Schema version: 80
#
# Table name: invoices
#
#  id            :integer(11)     not null, primary key
#  created_at    :datetime
#  event_id      :integer(11)     not null
#  status        :string(255)     not null
#  recognized    :boolean(1)      not null
#  payment_type  :string(255)     not null
#  oracle_string :string(255)     not null
#

class Invoice < ActiveRecord::Base
    has_many :invoice_lines, :dependent => :destroy;
    has_one :journal_invoice, :class_name => "Journal", :foreign_key => "link_id", :dependent => :destroy;
    belongs_to :event;
	
	Payment_Types = ["StuAct", "Check", "Oracle"];
    Invoice_Status_Group_All = ["New", "Quote", "Invoice", "Received" ];

    def total
        sum = 0;
        invoice_lines.each do |line|
            sum = sum + line.total;
        end
        return sum;
    end

    def total_sound
        sum = 0;
        invoice_lines.each do |line|
            if (line.category == "Sound")
                sum = sum + line.total;
            end
        end
        return sum;
    end


    def total_lighting
        sum = 0;
        invoice_lines.each do |line|
            if (line.category == "Lighting")
                sum = sum + line.total;
            end
        end
        return sum;
    end

    def itemized_list
        return invoice_lines.find(:all, :conditions => "category = 'Itemized' OR category = 'Reimbursement'");
    end

    validates_presence_of :status, :event;
    validates_inclusion_of :status, :in => Invoice_Status_Group_All;
    validates_associated :event;
end
