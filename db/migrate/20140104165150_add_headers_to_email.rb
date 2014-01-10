class AddHeadersToEmail < ActiveRecord::Migration
  def change
    add_column :emails, :headers, :text
  end
end
