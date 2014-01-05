module InvoiceHelper
  def self.generate_new_invoice()
    invoice = Invoice.new();
    InvoiceController::New_Invoice_New_Line_Display_Count.times do
      ln = InvoiceLine.new();
      invoice.invoice_lines << ln;
    end

    return invoice;
  end

  def self.update_invoice(invoice, params)
    errors = "";
    notices = "";
    
    # --------------------
    # create new invoice lines
    params['nlines'].to_i().times do |i|
      key = "line" + i.to_s();
      if(params[key]["id"] && ("" != params[key]["id"]))
        if(("" == params[key]["quantity"]) || (0 == params[key]["quantity"]))
          # delete it
          InvoiceLine.delete(params[key]["id"]);
        else
          line = InvoiceLine.update(params[key]["id"], params[key]);
        
          line.errors.each do |err|
            errors += err + "<br />";
          end
          
          if(line.valid?)
            line.save();
          end
        end
      else
        line = InvoiceLine.new(params[key]);
        line.invoice = invoice;

        if(line.valid?)
          invoice.invoice_lines << line;
        elsif(line.quantity && (line.quantity != 0))
          line.errors.each_full() do |err|
            errors += err + "<br />";
          end
        end
      end
    end

    if(params['journal_invoice_create'])
      params['journal_invoice']['amount']=invoice.total
      journal = JeInv.new(params['journal_invoice']);
      if(journal.valid?)
        invoice.journal_invoice = journal;
      else
        journal.errors.each do |err|
          errors += err + "<br />";
        end
      end
    end

    return notices, errors;
  end
end
