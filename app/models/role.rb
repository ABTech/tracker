class Role < ActiveRecord::Base
  has_and_belongs_to_many :permissions
  has_and_belongs_to_many :members

  #Only one role can mean "active" at a time
  validates_uniqueness_of :active, :if => Proc.new { |role| role.active? }

  def self.active
    find_by_active(true)
  end
end
