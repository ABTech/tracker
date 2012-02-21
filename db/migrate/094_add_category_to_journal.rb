class AddCategoryToJournal < ActiveRecord::Migration
  def self.up
    add_column "journals", "paymeth_category", :string
  end

  def self.down
    remove_column "journals", "paymeth_category"
  end
end
