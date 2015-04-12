class AddNotesToEventdates < ActiveRecord::Migration
  def change
    add_column :eventdates, :notes, :text
  end
end
