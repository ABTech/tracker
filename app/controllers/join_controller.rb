class JoinController < ApplicationController
  skip_before_action :authenticate_member!, :only => [:joinrequest]
  skip_before_action :verify_authenticity_token, :only => [:joinrequest]

  def joinrequest
    input = params.require([:andrew_id, :preferred_name, :last_name])

    andrewid = params['andrew_id'].downcase
    regex = /\A[a-z0-9]+\z/
    form_error = []
      
    if andrewid.blank?
      form_error << "Please enter your Andrew ID."
    elsif (andrewid =~ regex).nil? || andrewid.length > 8 || andrewid.length < 3
      form_error << "Invalid Andrew ID!"
    end

    if params['preferred_name'].blank? || params['last_name'].blank?
      form_error << "Please enter your name."
    end 
    
    if form_error.length > 0
      render json: form_error, status: 400
    else
      begin
         JoinRequestMailer.join_request(andrewid, params['preferred_name'], params['last_name']).deliver_now
      rescue
         head 500
      else
         head 200
      end
    end  

  end
end
