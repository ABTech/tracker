class JournalController < ApplicationController

  before_filter :login_required;

  def list
    @title = "List of Journals"
    @journals = Journal.find(:all)
  end

  def view
    @title = "Viewing JE"
    @mode = Mode_View;

    @journal = Journal.find(params['id']);
    
    render:layout=>"application2";
  end

  def new
    @title = "New JE"
    
    @journal = Journal.new();
    @journal.date = DateTime.now();

    render(:action => "new", :layout => "application2");
  end

  def edit
    @title = "Editing JE"
    @mode = Mode_Edit;
    
    @journal = Journal.find(params['id']);

    render :layout=>"application2";
  end
  def destroy
    @journal = Journal.find(params['id'])
    @journal.destroy

    flash[:notice] = "Successfully deleted #{@journal.memo} journal entry"
    redirect_to(:controller => "accounts", :action => "list");
  end

  def save
	errors = "";
	successfully_saved = 0;
	
	num_times = params["njournals"] ? params["njournals"].to_i : 1;
	num_times.times do |i|
		key = params["njournals"] ? ("journal" + i.to_s()) : "journal";
		if(params[key]["id"] && ("" != params[key]["id"]))
			journal = Journal.update(params[key]["id"], params[key]);
		else
			journal = Journal.new(params[key]);
			if (journal.memo == "" || journal.amount == 0)
				journal = nil
			end
		end
		
		if (journal && journal.valid? && journal.save())
			successfully_saved += 1;
		elsif (journal)
			journal.errors.each_full() do |err|
				errors += err + "<br />";
			end
		end
    if params[:attachments][i.to_s] and !journal.nil?
      Attachment.create(:attachment => params[:attachments][i.to_s], :journal_id => journal.id)
    end
	end

	flash[:error] = errors
	flash[:notice] = successfully_saved.to_s + " Journal(s) Saved";
	
    redirect_to(:controller => "accounts", :action => "list");
  end

end
