class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      # t.column :name, :string
      t.column "created_on", :datetime;
      t.column "message", :text, :null => false;
      t.column "priority", :integer, :null => false;
      t.column "member_id", :integer, :null => false;
    end
  end

  def self.down
    drop_table :pages
  end
end
