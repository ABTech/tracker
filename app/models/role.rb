class Role < ActiveRecord::Base
  has_and_belongs_to_many :permissions
  has_and_belongs_to_many :members
  
  attr_accessible :name, :info, :permission_ids, :active

  validate :only_one_active
  
  def self.active
    find_by_active(true)
  end
  
  private
    def only_one_active
      return unless active?

      matches = Role.where(active: true)
      if persisted?
        matches = matches.where('id != ?', id)
      end
      if matches.exists?
        errors.add(:active, 'cannot have another active role')
      end
    end
end
