class CreateEmailForms < ActiveRecord::Migration
  def change
    create_table :email_forms do |t|
      t.string :description
      t.text :contents

      t.timestamps
    end
  end
end
