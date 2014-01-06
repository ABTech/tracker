class SetMemberNicknameDefaultToBlank < ActiveRecord::Migration
  def change
    change_column :members, :namenick, :string, :default => ""
  end
end
