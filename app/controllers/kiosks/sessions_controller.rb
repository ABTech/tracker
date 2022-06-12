class Kiosks::SessionsController < Devise::SessionsController
    protect_from_forgery except: :create
 end
