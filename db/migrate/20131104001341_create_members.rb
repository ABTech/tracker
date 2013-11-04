class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.string :namefirst
      t.string :namelast
      t.string :kerbid
      t.string :namenick
      t.string :phone
      t.string :aim
      t.string :crypted_password
      t.string :salt
      t.string :remember_token
      t.datetime :remember_token_expires_at
      t.string :settingstring
      t.string :title
      t.string :callsign
      t.string :shirt_size
      t.integer :ssn
      t.float :payrate

      t.timestamps
    end
  end
end
