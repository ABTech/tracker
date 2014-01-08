class ConvertSsnToString < ActiveRecord::Migration
  def up
    add_column :members, :ssn_temp, :string
    
    Member.all.each do |member|
      if member.ssn.nil?
        member.ssn_temp = nil
      else
        member.ssn_temp = member.ssn.to_s.rjust(4, "0")
      end
      
      member.save! :validate => false
    end
    
    remove_column :members, :ssn
    rename_column :members, :ssn_temp, :ssn
  end
  
  def down
    rename_column :members, :ssn, :ssn_temp
    add_column :members, :ssn, :integer
    
    Member.all.each do |member|
      if member.ssn_temp.nil?
        member.ssn = nil
      else
        member.ssn = member.ssn_temp.to_i
      end
      
      member.save! :validate => false
    end
    
    remove_column :members, :ssn_temp
  end
end
