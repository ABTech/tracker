class AddBirthdayToMembers < ActiveRecord::Migration[6.1]
  def change
    add_column :members, :birthday, :date
  end
end
