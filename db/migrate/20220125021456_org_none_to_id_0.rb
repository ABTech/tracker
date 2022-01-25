class OrgNoneToId0 < ActiveRecord::Migration[6.1]
  def change
    if Organization.exists?(id: 162, name: "!none")
      execute "UPDATE events SET organization_id = 0 WHERE organization_id = 162"
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
