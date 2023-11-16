class EventRoleApplication < ApplicationRecord
  belongs_to :event_role
  belongs_to :member

  validates_presence_of :event_role, :member
  validate :event_role_is_appliable

  def superior
    position = event_role.superior
    unless position.nil?
      sup = event_role.roleable.event_roles.where(role: position).where.not(member: nil)
      return sup.map(&:member) unless sup.empty?
    end

    sup = event_role.roleable.tic_and_stic_only
    return sup unless sup.empty?

    []
  end

  def superior_name
    sup = superior
    return sup.map(&:display_name) unless sup.empty?
    ["the Head of Tech"]
  end

  def superior_email
    sup = superior
    return sup.map(&:email) unless sup.empty?
    ["abtech@andrew.cmu.edu"]
  end

  private
    def event_role_is_appliable
      errors.add(:event_role, "is not open to applications") unless event_role.appliable
    end
end
