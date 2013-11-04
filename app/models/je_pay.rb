class JePay < Journal
  belongs_to :payroll, :foreign_key => "link_id";
end
