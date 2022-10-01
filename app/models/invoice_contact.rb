class InvoiceContact < ApplicationRecord
  validates_format_of :email, with: Event::EmailRegex, multiline: true
  validates :email, uniqueness: true

  PERMANENT_INVOICE_CONTACTS = [
    'SLICEfinance@andrew.cmu.edu',
    'abtech+billing@andrew.cmu.edu'
  ].freeze
end
