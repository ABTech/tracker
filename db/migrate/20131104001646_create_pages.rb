class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.text :message
      t.integer :priority
      t.references :member, index: true

      t.timestamps
    end
  end
end
