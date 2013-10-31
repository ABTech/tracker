class JeLinkPaid < ActiveRecord::Migration
  def self.up
    add_column("journals", "link_paid_id", :integer);
  end

  def self.down
  end
end
