class CreateMemberFilters < ActiveRecord::Migration
  def change
    create_table :member_filters do |t|
      t.string :name
      t.string :filterstring
      t.integer :displaylimit
      t.references :member, index: true

      t.timestamps
    end
  end
end
