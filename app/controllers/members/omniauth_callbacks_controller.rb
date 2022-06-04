class Members::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: :saml_andrew

  def saml_andrew
    @member = Member.find_by_email(request.env["omniauth.auth"].uid)
    if @member
      sign_in_and_redirect @member, :event => :authentication
      set_flash_message(:notice, :success, :kind => 'Andrew SAML') if is_navigational_format?
    else
      set_flash_message(:error, :failure, :kind => 'Andrew SAML') if is_navigational_format?
      redirect_to root_url
    end
  end
end
