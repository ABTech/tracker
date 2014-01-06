class RestrictEventFinances < ActiveRecord::Migration
  def up
    p = Permission.new
    p.pattern = "events/(show|show_email|new|create|edit|update|destroy|delete_conf|filtered_events|index|calendar_full|iphone|mobile|mobile_email|calendar|generate|lost)"
    p.save!
    
    Role.where(id: [2, 10]).each do |gen|
      gen.permissions.delete(Permission.where(pattern: "events/*").first)
      gen.permissions << p
      gen.save!
    end
  end
  
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
