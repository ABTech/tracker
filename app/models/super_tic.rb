class SuperTic < ActiveRecord::Base
  belongs_to :member
  
  validates_uniqueness_of :day
  validates_inclusion_of :day, in: 1..7
  validate :member_is_exec
  
  def dayname
    puts self.inspect
    Date.commercial(2000, 1, day).strftime("%A")
  end
  
  def self.days
    (1..7).collect { |d| find_or_initialize_by(day: d) }
  end
  
  def self.available_for(member)
    where.not(member: member).count < 7
  end
  
  def self.extant_days
    order(day: :asc)
  end
  
  private
    def member_is_exec
      unless member.is_at_least? :exec
        errors.add(:member, "must be exec to be a super tic")
      end
    end
end
