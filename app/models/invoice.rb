# == Schema Information
# Schema version: 80
#
# Table name: invoices
#
#  id			:integer(11)	 not null, primary key
#  created_at	:datetime
#  event_id	  :integer(11)	 not null
#  status		:string(255)	 not null
#  recognized	:boolean(1)	  not null
#  payment_type  :string(255)	 not null
#  oracle_string :string(255)	 not null
#

class Invoice < ActiveRecord::Base
	has_many :invoice_lines, :dependent => :destroy;
	has_one :journal_invoice, :class_name => "Journal", :foreign_key => "invoice_id", :dependent => :destroy;
	belongs_to :event;
	
	Payment_Types = ["StuAct", "Check", "Oracle"];
	Invoice_Status_Group_All = ["New", "Quote", "Contract","Invoice", "Received" ];

	def total
		return invoice_lines.inject(0) {|sum,line| sum + line.total};
	end

	def total_sound
		return (invoice_lines.select {|line| line.category == "Sound"}).
			inject(0) {|sum,line| sum + line.total};
	end


	def total_lighting
		return (invoice_lines.select {|line| line.category == "Lighting"}).inject(0) {|sum,line| sum + line.total};
	end

	def itemized_list
		return invoice_lines.find(:all, :conditions => "category = 'Itemized' OR category = 'Reimbursement'");
	end

	validates_presence_of :status, :event;
	validates_inclusion_of :status, :in => Invoice_Status_Group_All;
	validates_associated :event;
end
