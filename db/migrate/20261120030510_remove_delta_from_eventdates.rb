class RemoveDeltaFromEventdates < ActiveRecord::Migration[6.1]
  # The delta flag was only used by Thinking Sphinx delta indexing.
  def change
    remove_column :eventdates, :delta, :boolean, default: true, null: false
  end
end
