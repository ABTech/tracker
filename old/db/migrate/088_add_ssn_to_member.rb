class AddSsnToMember < ActiveRecord::Migration
  def self.up
		add_column :members, :ssn, :integer
  end

  def self.down
		remove_column :members, :ssn
  end
end
