class JoinController < ApplicationController
  skip_before_action :authenticate_member!, :only => [:joinrequest]
  skip_before_action :verify_authenticity_token, :only => [:joinrequest]

  def joinrequest
    input = params.require([:andrew_id, :preferred_name, :last_name])

    special = "?<>',?[]}{=-)(*&^%$#`~{}"
    regex = /[#{special.gsub(/./){|char| "\\#{char}"}}]/
    form_error = [] 

    if params['andrew_id'] =~ regex || params['andrew_id'].length > 10 || params['andrew_id'].length < 2
      form_error << "Invalid Andrew ID!"
      
    end


    if params['preferred_name'].blank? || params['last_name'].blank?
      form_error << "Please enter your name."
    
    end 
      
    if params['andrew_id'].blank?
      form_error << "Please enter your Andrew ID."
    end
    
    if form_error.length > 0
      render json: form_error, status: 400
    else
      begin
         JoinRequestMailer.join_request(params['andrew_id'], params['preferred_name'], params['last_name']).deliver_now
      rescue
         head 500
      else
         head 200
      end
    end  

  end
end
