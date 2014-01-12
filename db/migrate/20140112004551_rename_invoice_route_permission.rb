class RenameInvoiceRoutePermission < ActiveRecord::Migration
  def up
    Permission.where("pattern LIKE ?", "invoice/%").each do |p|
      p.update_column(:pattern, "invoices/" + p.pattern[8..-1])
    end
  end
  
  def down
    Permission.where("pattern LIKE ?", "invoices/%").each do |p|
      p.update_column(:pattern, "invoice/" + p.pattern[9..-1])
    end
  end
end
