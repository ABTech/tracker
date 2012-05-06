class AddOrgEmailToOrganizations < ActiveRecord::Migration
  def self.up
    add_column :organizations, :org_email, :string
  end

  def self.down
    remove_column :organizations, :org_email
  end
end
