class AllowEventShowEmails < ActiveRecord::Migration
  def up
    p = Permission.new
    p.pattern = "events/show_email"
    p.save!
    
    Role.where(id: [2, 4, 10]).each do |r|
      r.permissions << p
      r.save!
    end
  end
  
  def down
    Permission.where(pattern: "events/show_email").first.destroy
  end
end
