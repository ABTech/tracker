class TimecardsController < ApplicationController
	before_filter :login_required
	layout 'application2'

	def index
		@timecards = Timecard.find(:all, :order => 'billing_date DESC')
	end

	def show
		@timecard = Timecard.find(params[:id])
		@member = current_member
		if params[:format] == 'txt'
			headers['Content-Type'] = 'text/plain'
			headers['Content-Disposition'] = 'inline'
			render :layout => false, :partial => 'timecard', :locals => { :timecard => @timecard, :member => @member}
		elsif params[:format] == 'pdf'
			headers['Content-Type'] = 'application/pdf'
			headers['Content-Disposition'] = 'inline'
			render :layout => false, :action => 'print'
		end
	end

	def new
		@timecard = Timecard.new
		@timecard.billing_date = Timecard.latest_dates.billing_date + 14*24*60*60
		@timecard.due_date = Timecard.latest_dates.due_date + 14*24*60*60
	end

	def create
		@timecard = Timecard.new(params[:timecard])
		if @timecard.save
			redirect_to :action => 'index'
		else
			render :action => 'new'
		end
	end

	def edit
		@timecard = Timecard.find(params[:id])
	end

	def update
		@timecard = Timecard.find(params[:id])
		if @timecard.update_attributes(params[:timecard])
			flash[:notice] = 'Timecard updated successfully'
			redirect_to :action => 'show'
		else
			render :action => 'edit'
		end
	end

	def destroy
		@timecard = Timecard.find(params[:id])
		@timecard.destroy
		redirect_to :action => 'index'
	end
end
