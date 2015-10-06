class DeletePriceQuote < ActiveRecord::Migration
  def change
    remove_column :events, :price_quote
  end
end
