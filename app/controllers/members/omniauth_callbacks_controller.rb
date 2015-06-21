class Members::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def shibboleth
    @member = Member.find_by_email(request["omniauth.auth"].uid)
    if @member
      sign_in_and_redirect @member, :event => :authentication
      set_flash_message(:notice, :success) if is_navigational_format?
    else
      set_flash_message(:error, :failure) if is_navigational_format?
      redirect_to root_url
    end
  end

end
