class CreateSuperTics < ActiveRecord::Migration
  def change
    create_table :super_tics do |t|
      t.references :member, index: true
      t.integer :day

      t.timestamps
    end
  end
end
