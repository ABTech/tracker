class AddProfileOptionViewFullName < ActiveRecord::Migration[6.1]
  def change
    # Change members table; Add column prefers_full_name
    add_column :members, :prefers_full_name, :boolean, default: false, null: false
  end
end
