class AddBillablesToEventdate < ActiveRecord::Migration[6.1]
  def change
    add_column :eventdates, :billable_call, :boolean, :default => false
    add_column :eventdates, :billable_show, :boolean, :default => true
    add_column :eventdates, :billable_strike, :boolean, :default => false
  end
end
