class AddRecoverableToMember < ActiveRecord::Migration
  def change
    add_column :members, :reset_password_token, :string
    add_column :members, :reset_password_sent_at, :datetime
  end
end
