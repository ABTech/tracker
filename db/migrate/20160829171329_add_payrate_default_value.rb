class AddPayrateDefaultValue < ActiveRecord::Migration[5.0]
  def change
    change_column_default :members, :payrate, 7.25
  end
end
