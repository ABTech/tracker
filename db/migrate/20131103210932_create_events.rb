class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.references :organization, index: true
      t.string :status
      t.string :contactemail
      t.boolean :blackout
      t.boolean :publish
      t.boolean :rental
      t.references :year, index: true
      t.string :contact_name
      t.string :contact_phone
      t.integer :price_quote
      t.text :notes

      t.timestamps
    end
  end
end
