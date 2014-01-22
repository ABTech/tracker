class EmailFormsController < ApplicationController
  before_filter :authenticate_member!

  def index
    @title = "Form Emails"

    @emailforms = EmailForm.find(:all)
  end

  def new
    @title = "New Form Email"

    @emailform = EmailForm.new
  end

  def create
    @emailform = EmailForm.new(params[:email_form])
    if @emailform.save()
      flash[:notice] = 'Form Email was successfully created.'
      redirect_to email_forms_url
    else
      render(:action => 'new')
    end
  end

  def edit
    @title = "Editing Form Email"

    @emailform = EmailForm.find(params[:id])
  end

  def update
    @emailform = EmailForm.find(params[:id])
    if @emailform.update_attributes(params[:email_form])
      flash[:notice] = 'Form Email was successfully updated.'
      redirect_to email_forms_url
    else
      render(:action => 'edit')
    end
  end

  def destroy
    EmailForm.find(params[:id]).destroy()
    redirect_to email_forms_url
  end
end
