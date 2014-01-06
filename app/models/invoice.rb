class Invoice < ActiveRecord::Base
  belongs_to :event
  has_many :invoice_lines, :dependent => :destroy
  has_one :journal_invoice, :class_name => "Journal", :foreign_key => "invoice_id", :dependent => :destroy

  Payment_Types = ["StuAct", "Check", "Oracle"]
  Invoice_Status_Group_All = ["New", "Quote", "Contract","Invoice", "Received" ]

  attr_accessible :event_id, :status, :recognized, :payment_type, :oracle_string, :memo

  validates_presence_of :status, :event, :event_id
  validates_inclusion_of :status, :in => Invoice_Status_Group_All
  validates_associated :event

  def total
    return invoice_lines.inject(0) {|sum,line| sum + line.total};
  end

  def total_sound
    return (invoice_lines.select {|line| line.category == "Sound"}).inject(0) {|sum,line| sum + line.total};
  end

  def total_lighting
    return (invoice_lines.select {|line| line.category == "Lighting"}).inject(0) {|sum,line| sum + line.total};
  end

  def itemized_list
    return invoice_lines.find(:all, :conditions => "category = 'Itemized' OR category = 'Reimbursement'");
  end
  
  def display_title
    if not (memo.nil? or memo.empty?)
      "Invoice at " + created_at.strftime("%A, %B %d at %I:%M %p") + " - " + memo
    else
      "Invoice at " + created_at.strftime("%A, %B %d at %I:%M %p")
    end
  end
end
