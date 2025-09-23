class DefaultToShowFullNames < ActiveRecord::Migration[6.1]
  def change
    change_column_default :members, :prefers_full_name, from: false, to: true
  end
end
