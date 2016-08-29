class AddAimDefaultValue < ActiveRecord::Migration[5.0]
  def change
    change_column_default :members, :aim, ""
  end
end
