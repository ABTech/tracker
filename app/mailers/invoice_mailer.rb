class InvoiceMailer < ActionMailer::Base
  def invoice(invoice,invoice_attachment, params)
    attachments["#{invoice.event.title}-#{invoice.status}#{invoice.id}.pdf"] = invoice_attachment
    
    mail :to => params[:to],
         :cc => params[:cc],
         :from => "abtech+billing@andrew.cmu.edu",
         :reply_to => "abtech+billing@andrew.cmu.edu",
         :subject => params[:subject] do |format|
      format.text { render text: params[:content] }
    end
  end
end
