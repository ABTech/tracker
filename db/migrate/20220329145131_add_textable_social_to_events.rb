class AddTextableSocialToEvents < ActiveRecord::Migration[6.1]
  def change
    add_column :events, :textable_social, :boolean, null: false, default: false
  end
end
