class CreateEventdateRoles < ActiveRecord::Migration
  def change
    create_table :eventdate_roles do |t|
      t.references :eventdate, index: true
      t.references :member, index: true
      t.string :role

      t.timestamps
    end
  end
end
