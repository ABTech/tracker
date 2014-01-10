class AllowEventsShowFinance < ActiveRecord::Migration
  def up
    p = Permission.new
    p.pattern = "events/finance"
    p.save!
    
    Role.where(id: [4]).each do |r|
      r.permissions << p
      r.save!
    end
  end
  
  def down
    Permission.where(pattern: "events/finance").first.destroy
  end
end
