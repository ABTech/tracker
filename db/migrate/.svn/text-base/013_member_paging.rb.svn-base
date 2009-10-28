class MemberPaging < ActiveRecord::Migration
  def self.up
      create_table("pagers") do |t| end
      add_column("pagers", "pagertype", :string, :null => false);
      add_column("pagers", "connection", :string);
      add_column("pagers", "member_id", :integer, :null => false);
  end

  def self.down
  end
end
