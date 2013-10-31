class AddActiveToRoles < ActiveRecord::Migration
  def self.up
    add_column :roles, :active, :boolean, {:null => false, :default => false}
    Role.reset_column_information

    Role.find(:all).each do |r|
      r.update_attribute :active, false
    end
  end

  def self.down
    remove_column :roles, :active
  end
end
