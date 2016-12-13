class EventRoleApplication < ApplicationRecord
  belongs_to :event_role
  belongs_to :member
  
  validates_presence_of :event_role, :member
  
  def superior
    position = event_role.superior
    unless position.nil?
      sup = event_role.roleable.event_roles.where(role: position).where.not(member: nil)
      return sup.map(&:member) unless sup.empty?
      
      sup = event_role.roleable.tic
      return sup unless sup.empty?
    end
    
    []
  end
  
  def superior_name
    sup = superior
    return sup.map(&:fullname) unless sup.empty?
    ["the Head of Tech"]
  end
  
  def superior_email
    sup = superior
    return sup.map(&:email) unless sup.empty?
    ["abtech@andrew.cmu.edu"]
  end
end
