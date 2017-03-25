class AddPayrollSubmissionField < ActiveRecord::Migration[5.0]
  def change
    add_column :members, :on_payroll, :boolean, default: false, null: false
  end
end
