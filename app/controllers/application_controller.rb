class ApplicationController < ActionController::Base
include AuthenticatedSystem
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  layout "events"

  before_filter :login_from_cookie

  Application_Name  = "ABTT";
  Application_URL   = "https://abtt.abtech.org"

  Mode_View = "View";
  Mode_Edit = "Edit";
  Mode_New  = "Create";

  def sanitize_params
    walk_hash(params)
  end

  def sanitize_param(param)
    param.gsub("<", "&lt;")
  end

  def walk_hash(hash)
    hash.keys.each do |key|
      if hash[key].is_a? String
        hash[key] = sanitize_param(hash[key])
      elsif hash[key].is_a? Hash
        hash[key] = walk_hash(hash[key])
      elsif hash[key].is_a? Array
        hash[key] = walk_array(hash[key])
      end
    end
    hash
  end

  def walk_array(array)
    array.each_with_index do |el,i|
      if el.is_a? String
        array[i] = sanitize_param(el)
      elsif el.is_a? Hash
        array[i] = walk_hash(el)
      elsif el.is_a? Array
        array[i] = walk_array(el)
      end
    end
    array
  end

  def iphone_user_agent?
    request.env["HTTP_USER_AGENT"] && request.env["HTTP_USER_AGENT"][/(iphone|ipod|android|blackberry)/i]
  end
end
