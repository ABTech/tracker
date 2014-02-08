class RemoveOrganizationsEmail < ActiveRecord::Migration
  def change
    remove_column :organizations, :org_email, :string
  end
end
