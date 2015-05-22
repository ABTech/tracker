class AddWillReceiveEmailsToMember < ActiveRecord::Migration
  def change
    add_column :members, :receives_comment_emails, :boolean, :null => false, :default => false
  end
end
