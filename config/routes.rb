ActionController::Routing::Routes.draw do |map|
  map.resources :permissions
  map.resources :roles
  map.resources :locations
  map.resources :comments
  map.resources :members, :collection => [:edit_self]
  map.resources :accounts, :collection => {:list => :get, :unpaid => :get, :unpaid_print => :get, :events => :get}

  map.connect "calendar/generate.:format", :controller => "events", :action => "generate"
  map.connect "calendar", :controller => "events", :action => "calendar";

  map.connect "mobile", :controller => "events", :action => "mobile";
  map.connect "iphone", :controller => "events", :action => "iphone";
  map.connect "i", :controller => "events", :action => "iphone";
  map.connect "invoice/email/:id", :controller =>"invoice", :action=>"email", :conditions => {:method=>:post}

  map.resources :organizations
  map.resources :bugs
  map.resources :tshirts
  map.connect "invoice/list", :controller => "invoice", :action => "list"
  map.resources :invoice
  map.resources :timecard_entries, :except => ['show']
	map.resources :timecards, :member => {:view => :get }
  map.resources :events,
                :member => [:delete_conf, :mobile_email],
                :collection => [:calendar, :iphone, :mobile, :lost]

  map.resources :attachments, :only => ["index", "destroy"]

  map.resource :version, :controller => :version, :only => ["show"] 

  map.connect "login", :controller => "useraccount", :action => "login"
  map.connect "logout", :controller => "useraccount", :action => "logout"

  map.root :controller => "events", :action => "index" 

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id'
end
