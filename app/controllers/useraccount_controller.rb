class UseraccountController < ApplicationController

  def login
    login_member = Member.authenticate(params["login"], params["password"]);
    if(login_member)
        self.current_member = login_member;
    end

    if(current_member)
      #Well, of course we are fat!
      if(params["remember_me"] == "1" or true)
          #self.current_member.remember_me();
          cookies[:auth_token] = { :value => self.current_member.remember_token , :expires => self.current_member.remember_token_expires_at }
      end

      if(iphone_user_agent?)
        redirect_to(:controller => "events", :action => "iphone")
      else
        redirect_back_or_default(:controller => 'events', :action => 'index')
      end

    else
      flash[:error] = "Username or password incorrect.";

      render(:action => "login", :layout => false);
    end
  end

  def logout
    if(logged_in?)
      self.current_member.forget_me();
    end
    cookies.delete( :auth_token );
    reset_session();

    flash[:notice] = "You have been logged out.";
    redirect_back_or_default(:controller => 'events', :action => 'index')
  end

  def access_denied
    @title = "Access Denied";
    render(:action => "login", :layout => false);
  end
end
