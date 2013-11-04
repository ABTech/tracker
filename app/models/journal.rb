class Journal < ActiveRecord::Base
  belongs_to :invoice
  belongs_to :account
  belongs_to :event
end
