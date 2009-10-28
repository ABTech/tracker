class CreateBugs < ActiveRecord::Migration
  def self.up
    create_table :bugs do |t|
      t.column :member_id, :integer
      t.column :submitted_on, :datetime
      t.column :description, :text
      t.column :confirmed, :boolean
      t.column :resolved, :boolean
      t.column :resolved_on, :datetime
      t.column :comment, :text
      t.column :closed, :boolean
      t.column :priority, :string
      t.column :updated_at, :datetime
      t.column :crated_at, :datetime
    end
  end

  def self.down
    drop_table :bugs
  end
end
