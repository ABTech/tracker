class AddPronounsToMember < ActiveRecord::Migration[5.0]
  def change
    add_column :members, :pronouns, :string
  end
end
