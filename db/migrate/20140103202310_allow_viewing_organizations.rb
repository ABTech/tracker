class AllowViewingOrganizations < ActiveRecord::Migration
  def up
    p = Permission.new
    p.pattern = "organizations/(index|show)"
    p.save!
    
    Role.all.each do |role|
      role.permissions << p
      role.save!
    end
  end
  
  def down
    Permission.where(pattern: "organizations/(index|show)").first.destroy
  end
end
