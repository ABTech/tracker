class AddQuoteToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :price_quote, :integer
  end

  def self.down
    remove_column :events, :price_quote
  end
end
