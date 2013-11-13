module AuthenticatedSystem
  protected
    # Returns true or false if the user is logged in.
    # Preloads @current_member with the user model if they're logged in.
    def logged_in?
      (@current_member ||= session[:member] ? Member.find_by_id(session[:member]) : :false).is_a?(Member)
    end
    
    # Accesses the current member from the session.
    def current_member
      @current_member if logged_in?
    end
    
    # Store the given member in the session.
    def current_member=(new_member)
      session[:member] = (new_member.nil? || new_member.is_a?(Symbol)) ? nil : new_member.id
      @current_member = new_member
    end
    
    # Check if the member is authorized.
    #
    # Override this method in your controllers if you want to restrict access
    # to only a few actions or if you want to check if the member
    # has the correct rights.
    #
    # Example:
    #
    #  # only allow nonbobs
    #  def authorize?
    #    current_member.login != "bob"
    #  end
    def authorized?
        required_perm = "%s/%s" % [ params['controller'], params['action'] ]

        if(!current_member)
            return false;
        end

        if(!current_member.authorized?(required_perm))
            errstr = "User #{current_member.kerbid} failed access rights for permission #{required_perm}.";
            puts errstr;
            flash[:error] = errstr;

            return false;
        end

        return true;
    end

    # Filter method to enforce a login requirement.
    #
    # To require logins for all actions, use this in your controllers:
    #
    #   before_filter :login_required
    #
    # To require logins for specific actions, use this in your controllers:
    #
    #   before_filter :login_required, :only => [ :edit, :update ]
    #
    # To skip this in a subclassed controller:
    #
    #   skip_before_filter :login_required
    #
    def login_required
        username, passwd = get_auth_data();

        if(username && passwd && !Member.authenticate(username, passwd))
            self.current_member = nil;
        end

        if(logged_in? && authorized?)
            return true;
        else
            access_denied();
            return false;
        end
    end
    
    # Redirect as appropriate when an access request fails.
    #
    # The default action is to redirect to the login screen.
    #
    # Override this method in your controllers if you want to have special
    # behavior in case the member is not authorized
    # to access the requested action.  For example, a popup window might
    # simply close itself.
    def access_denied()
        redirect_to(:action => "access_denied", :controller => "useraccount");
    end
    
    # Store the URI of the current request in the session.
    #
    # We can return to this location by calling #redirect_back_or_default.
    def store_location
      session[:return_to] = request.request_uri unless request.request_uri == request.request_referrer 
    end
    
    # Redirect to the URI stored by the most recent store_location call or
    # to the passed default.
    def redirect_back_or_default(default)
      session[:return_to] ? redirect_to_url(session[:return_to]) : redirect_to(default)
      session[:return_to] = nil
    end
    
    # Inclusion hook to make #current_member and #logged_in?
    # available as ActionView helper methods.
    def self.included(base)
      base.send :helper_method, :current_member, :logged_in?
    end

    # When called with before_filter :login_from_cookie will check for an :auth_token
    # cookie and log the user back in if apropriate
    def login_from_cookie
      return unless cookies[:auth_token] && !logged_in?
      user = Member.find_by_remember_token(cookies[:auth_token])
      if user && user.remember_token?
        #user.remember_me
        self.current_member = user
        cookies[:auth_token] = { :value => self.current_member.remember_token , :expires => self.current_member.remember_token_expires_at }
        flash[:notice] = "Logged in successfully"
      end
    end

  private
    # gets BASIC auth info
    def get_auth_data
      user, pass = nil, nil
      # extract authorisation credentials 
      if request.env.has_key? 'X-HTTP_AUTHORIZATION' 
        # try to get it where mod_rewrite might have put it 
        authdata = request.env['X-HTTP_AUTHORIZATION'].to_s.split 
      elsif request.env.has_key? 'HTTP_AUTHORIZATION' 
        # this is the regular location 
        authdata = request.env['HTTP_AUTHORIZATION'].to_s.split  
      end 
       
      # at the moment we only support basic authentication 
      if authdata && authdata[0] == 'Basic' 
        user, pass = Base64.decode64(authdata[1]).split(':')[0..1] 
      end 
      return [user, pass] 
    end
end
