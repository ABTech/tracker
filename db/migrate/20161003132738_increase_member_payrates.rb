class IncreaseMemberPayrates < ActiveRecord::Migration[5.0]
  def up
    Member.active.each do |m|
      m.payrate += 1.0
      m.save
    end
  end
  
  def down
    Member.active.each do |m|
      m.payrate -= 1.0
      m.save
    end
  end
end
