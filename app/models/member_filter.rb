class MemberFilter < ActiveRecord::Base
  belongs_to :member

  validates_presence_of :name, :displaylimit;

  def filters
    if(filterstring)
      return filterstring.split(",");
    else
      return []
    end
  end

  def filters=(what)
    self.filterstring = what.join(",");
  end
end
