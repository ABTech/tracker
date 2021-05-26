class Invoice < ApplicationRecord
  belongs_to :event
  has_many :invoice_lines, :dependent => :destroy, :inverse_of => :invoice

  amoeba do
    include_association [:invoice_lines]
  end

  Payment_Types = ["StuAct", "Check", "Oracle"]
  Invoice_Status_Group_All = ["New", "Quote", "Contract","Invoice", "Received","Loan Agreement"]
  Invoice_Status_Group_Exec = ["New", "Quote"]
  
  accepts_nested_attributes_for :invoice_lines, :allow_destroy => true

  validates_presence_of :status, :event, :event_id
  validates_inclusion_of :status, :in => Invoice_Status_Group_All
  validates_associated :event
  validate :event_is_in_current_year, :on => :create
  
  before_validation :prune_lines

  def total
    invoice_lines.collect(&:total).reduce(:+)
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

    def event_is_in_current_year
      unless event.current_year?
        errors.add(:event, "is not in the current billing year")
      end
    end

end
