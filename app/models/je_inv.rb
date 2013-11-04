class JeInv < Journal
  belongs_to :invoice, :foreign_key => "link_id";
  belongs_to :je_paid, :foreign_key => "link_paid_id";
end
