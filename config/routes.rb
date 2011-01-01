ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  # map.connect '', :controller => "welcome"

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  map.connect "calendar/generate.:format", :controller => "event", :action => "generate"
  map.connect "calendar", :controller => "event", :action => "calendar";

  map.connect "mobile", :controller => "event", :action => "mobile";
  map.connect "iphone", :controller => "event", :action => "iphone";
  map.connect "i", :controller => "event", :action => "iphone";

  map.resources :organizations
  map.resources :bugs
  map.resources :timecard_entries, :except => ['show']
	map.resources :timecards, :member => {:view => :get }

  map.resources :attachments, :only => ["index", "destroy"]

  map.connect '',   :controller => "event", :action => "list" 

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id'
end
