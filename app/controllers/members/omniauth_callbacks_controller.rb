class Members::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: :saml_andrew

  def saml_andrew
    @member = Member.find_by_email(request.env["omniauth.auth"].uid)
    if @member
      sign_in_and_redirect @member, :event => :authentication
      set_flash_message(:notice, :success, :kind => 'Andrew SAML') if is_navigational_format?
    else
      session["devise.andrew_saml_data.uid"] = request.env["omniauth.auth"].uid
      redirect_to root_path
      set_flash_message(:error, :failure, :kind => 'Andrew SAML', :reason => 'Your account is not registered.') if is_navigational_format?
    end
  end
end
