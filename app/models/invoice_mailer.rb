class InvoiceMailer < ActionMailer::Base
  def invoice(invoice,invoice_attachment)
    #set the various header bits
    recipients  invoice.event.contactemail
    cc "afasulo@andrew.cmu.edu,abtech+billing@andrew.cmu.edu"
    from "abtech+billing@andrew.cmu.edu"
    headers "Reply-To" => "abtech+billing@andrew.cmu.edu"
    subject "AB Tech Billing For #{invoice.event.title}"   
   
    #Add invoice pdf attachment
    attachment "application/pdf" do |a|
      a.body = invoice_attachment
      a.filename = "#{invoice.event.title}-#{invoice.status}#{invoice.id}.pdf"
    end

  end
end
