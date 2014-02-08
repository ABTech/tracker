class RenameKerbidToEmail < ActiveRecord::Migration
  def change
    rename_column :members, :kerbid, :email
  end
end
