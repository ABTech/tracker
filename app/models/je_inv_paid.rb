class JeInvPaid < Journal
  belongs_to :invoice, :foreign_key => "link_id";
end
