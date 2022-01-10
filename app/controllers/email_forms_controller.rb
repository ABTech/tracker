class EmailFormsController < ApplicationController
  load_and_authorize_resource :except => [:create]
  
  def index
    @title = "Form Emails"
  end

  def new
    @title = "New Form Email"
  end

  def create
    @email_form = EmailForm.new(email_form_params)
    authorize! :create, @email_form
    
    if @email_form.save
      flash[:notice] = 'Form Email was successfully created.'
      redirect_to email_forms_url
    else
      render(:action => 'new')
    end
  end

  def edit
    @title = "Editing Form Email"
  end

  def update
    if @email_form.update(email_form_params)
      flash[:notice] = 'Form Email was successfully updated.'
      redirect_to email_forms_url
    else
      render(:action => 'edit')
    end
  end

  def destroy
    @email_form.destroy
    redirect_to email_forms_url
  end
  
  private
    def email_form_params
      params.require(:email_form).permit(:description, :contents)
    end
end
