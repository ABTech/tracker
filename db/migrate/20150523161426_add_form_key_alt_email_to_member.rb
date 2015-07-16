class AddFormKeyAltEmailToMember < ActiveRecord::Migration
  def change
    add_column :members, :payroll_paperwork_date, :datetime
    add_column :members, :ssi_date, :datetime
    add_column :members, :driving_paperwork_date, :datetime
    add_column :members, :key_possession, :string, null: false, default: "none"
    add_column :members, :alternate_email, :string
  end
end
