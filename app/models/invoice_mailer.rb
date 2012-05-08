class InvoiceMailer < ActionMailer::Base
  def invoice(invoice,invoice_attachment, params)
    #set the various header bits
    recipients params[:to]
    cc params[:cc]
    from "abtech+billing@andrew.cmu.edu"
    headers "Reply-To" => "abtech+billing@andrew.cmu.edu"
    subject params[:subject]
    @body[:content] = params[:content]
   
    #Add invoice pdf attachment
    attachment "application/pdf" do |a|
      a.body = invoice_attachment
      a.filename = "#{invoice.event.title}-#{invoice.status}#{invoice.id}.pdf"
    end

  end
end
