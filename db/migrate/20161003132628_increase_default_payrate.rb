class IncreaseDefaultPayrate < ActiveRecord::Migration[5.0]
  def change
    change_column_default :members, :payrate, 8.25
  end
end
