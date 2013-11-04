class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name
      t.integer :parent_id
      t.string :org_email

      t.timestamps
    end
  end
end
