class UserFilterCreate < ActiveRecord::Migration
  def self.up
    create_table(:member_filters) do |t|
        t.column "name", :string, :null => false
        t.column "filterstring", :string
        t.column "displaylimit", :integer, :null => false
    end
  end

  def self.down
  end
end
