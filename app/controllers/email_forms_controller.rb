class EmailFormsController < ApplicationController

  before_filter :login_required;

  def list
    @title = "Email Form Responses"

    @emailforms = EmailForm.find(:all);
  end

  def show
    @title = "Viewing Form Responses"

    @emailform = EmailForm.find(params[:id])
  end

  def new
    @title = "New Form Responses"

    @emailform = EmailForm.new
  end

  def create
    @emailform = EmailForm.new(params[:emailform])
    if @emailform.save()
      flash[:notice] = 'Form Response was successfully created.'
      redirect_to(:action => 'list')
    else
      render(:action => 'new')
    end
  end

  def edit
    @title = "Editing Form Response"

    @emailform = EmailForm.find(params[:id])
  end

  def update
    @emailform = EmailForm.find(params[:id])
    if @emailform.update_attributes(params[:emailform])
      flash[:notice] = 'Email Form Response was successfully updated.'
      redirect_to(:action => 'show', :id => @emailform)
    else
      render(:action => 'edit')
    end
  end

  def destroy
    EmailForm.find(params[:id]).destroy()
    redirect_to(:action => 'list')
  end
end
