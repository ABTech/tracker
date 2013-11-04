class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.string :pattern

      t.timestamps
    end
  end
end
