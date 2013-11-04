class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :name
      t.boolean :is_credit
      t.integer :position

      t.timestamps
    end
  end
end
