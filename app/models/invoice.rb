class Invoice < ActiveRecord::Base
  belongs_to :event
  has_many :invoice_lines, :dependent => :destroy;
  has_one :journal_invoice, :class_name => "Journal", :foreign_key => "invoice_id", :dependent => :destroy;

  validates_presence_of :status, :event, :event_id
  validates_inclusion_of :status, :in => Invoice_Status_Group_All;
  validates_associated :event;
	
  Payment_Types = ["StuAct", "Check", "Oracle"];
  Invoice_Status_Group_All = ["New", "Quote", "Contract","Invoice", "Received" ];

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
end
