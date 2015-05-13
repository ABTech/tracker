class AddExtraEmailHeaders < ActiveRecord::Migration
  def change
    add_column :emails, :in_reply_to, :string
  end
end
