class Allocation < ActiveRecord::Base
  validates_uniqueness_of :line_item
  has_many :journals
  
  def spent
    scope = self.journals.includes(:account).references(:account)
    scope.where("accounts.is_credit = TRUE").sum(:amount) - scope.where("accounts.is_credit = FALSE").sum(:amount)
  end
  
  def remaining
    self.budget - self.spent
  end
end
