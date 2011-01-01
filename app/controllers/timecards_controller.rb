class TimecardsController < ApplicationController
	before_filter :login_required
	layout 'application2'

	def index
		@timecards = Timecard.find(:all, :conditions => {:member_id => current_member.id}, :order => 'billing_date DESC')
	end

	def all
		@timecards = Timecard.find(:all, :order => 'billing_date DESC')
	end

	def show
		@timecard = Timecard.find(params[:id])
		if params[:format] == 'txt'
			headers['Content-Type'] = 'text/plain'
			headers['Content-Disposition'] = 'inline'
			render :layout => false, :partial => 'timecard', :object => @timecard
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
		@members = Member.find(:all)
	end

	def create
		@timecard = Timecard.new(params[:timecard])
		if @timecard.save
			redirect_to :action => 'index'
		else
			render :action => 'new'
		end
	end

	def submit
		@timecard = Timecard.find(params[:id])
		@timecard.submitted = true
		if @timecard.save
			flash[:notice] = 'Timecard is marked as submitted'
		else
			flash[:notice] = 'There was an error marking this timecard as submitted'
		end
		redirect_to :action => 'show'
	end

end
