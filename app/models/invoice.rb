class Invoice < ApplicationRecord
  belongs_to :event
  has_many :invoice_lines, :dependent => :destroy, :inverse_of => :invoice
  has_one :journal_invoice, :class_name => "Journal", :foreign_key => "invoice_id", :dependent => :destroy

  Payment_Types = ["StuAct", "Check", "Oracle"]
  Invoice_Status_Group_All = ["New", "Quote", "Contract","Invoice", "Received","Loan Agreement"]
  Invoice_Status_Group_Exec = ["New", "Quote"]
  
  accepts_nested_attributes_for :invoice_lines, :allow_destroy => true
  accepts_nested_attributes_for :journal_invoice

  attr_accessor :update_journal

  validates_presence_of :status, :event, :event_id
  validates_inclusion_of :status, :in => Invoice_Status_Group_All
  validates_associated :event
  validate :event_is_in_current_year, :on => :create
  
  before_validation :prune_lines
  after_save :update_je_total

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

  private
    def prune_lines
      self.invoice_lines = self.invoice_lines.reject do |line|
        line.memo.empty? and line.price.nil? and line.quantity.nil?
      end
    end
    
    def update_je_total
      if self.update_journal == "1"
        self.journal_invoice.amount = self.total
        self.journal_invoice.save
      end
    end

    def event_is_in_current_year
      unless event.current_year?
        errors.add(:event, "is not in the current billing year")
      end
    end

end
