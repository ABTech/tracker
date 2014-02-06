class RetroactivelyFixEmailSubjects < ActiveRecord::Migration
  def up
    Email.all.each do |e|
      e.update_column(:subject, Mail::Encodings.value_decode(e.subject).encode("US-ASCII", {:invalid => :replace, :undef => :replace, :replace => ''}))
    end
  end
  
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
