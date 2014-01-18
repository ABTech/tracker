module InvoicesHelper
  
  def link_to_create_invoice_je f
    new_object = f.object.class.reflect_on_association(:journal_invoice).klass.new
    fields = f.fields_for("journal_invoice", new_object, :child_index => "new_journal_invoice") do |builder|
      render("journal_invoice_fields", :f => builder)
    end
    fields += f.hidden_field :update_journal, value: "1"
    link_to("Create?", "#", class:"replace_field", data: {association: "journal_invoice", content: "#{fields}", repid: "createje"}, onClick: "return false")
  end
  
  def link_to_mark_invoice_paid f
    new_object = f.object.journal_invoice
    fields = f.fields_for("journal_invoice", new_object, :child_index => "new_journal_invoice") do |builder|
      render("journal_invoice_mark_paid_fields", :f => builder)
    end
    link_to("Mark paid?", "#", class:"replace_field", data: {association: "journal_invoice", content: "#{fields}", repid: "markje"}, onClick: "return false")
  end
  
end
