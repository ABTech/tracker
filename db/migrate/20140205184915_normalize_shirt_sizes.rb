class NormalizeShirtSizes < ActiveRecord::Migration
  def up
    Member.all.each do |m|
      if m.shirt_size.nil?
        m.update_column(:shirt_size, nil)
      end
    end
  end
  
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
