class RemoveMemberFromTimecards < ActiveRecord::Migration
  def self.up
		remove_column :timecards, :member_id
  end

  def self.down
		add_column :timecards, :member_id, :integer
  end
end
