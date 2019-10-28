class AddMemberDetailsToMembers < ActiveRecord::Migration[5.0]
  def change
    add_column :members, :favorite_entropy_drink, :string
    add_column :members, :major, :string
    add_column :members, :grad_year, :string
    add_column :members, :interests, :string
    add_column :members, :officer_position, :string
  end
end
