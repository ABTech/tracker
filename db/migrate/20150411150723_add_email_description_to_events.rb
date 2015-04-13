class AddEmailDescriptionToEvents < ActiveRecord::Migration
  def change
    add_column :eventdates, :email_description, :text
  end
end
