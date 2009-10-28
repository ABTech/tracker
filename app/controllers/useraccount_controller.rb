class UseraccountController < ApplicationController
	filter_parameter_logging :password;

    def login
        login_member = Member.authenticate(params["login"], params["password"]);
        if(login_member)
            self.current_member = login_member;
        end

        if(current_member)
            if(params["remember_me"] == "1")
                self.current_member.remember_me();
                cookies[:auth_token] = { :value => self.current_member.remember_token , :expires => self.current_member.remember_token_expires_at }
            end

	    if(params["iphone"])
	      redirect_to(:controller => "event", :action => "iphone")
	    else
	      redirect_back_or_default(:controller => '/event', :action => 'list')
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
        redirect_back_or_default(:controller => '/event', :action => 'list')
    end

    def access_denied
        @title = "Access Denied";
        render(:action => "login", :layout => false);
    end
end
