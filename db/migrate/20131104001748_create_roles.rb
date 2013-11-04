class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :name
      t.string :info
      t.boolean :active

      t.timestamps
    end
  end
end
