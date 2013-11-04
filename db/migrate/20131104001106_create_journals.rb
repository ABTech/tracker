class CreateJournals < ActiveRecord::Migration
  def change
    create_table :journals do |t|
      t.datetime :date
      t.string :memo
      t.references :invoice, index: true
      t.decimal :amount
      t.datetime :date_paid
      t.text :notes
      t.references :account, index: true
      t.references :event, index: true
      t.string :paymeth_category

      t.timestamps
    end
  end
end
