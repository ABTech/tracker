class EventRoleApplicationsController < ApplicationController
  
  def new
    @event_role = EventRole.find(params[:event_role_id])
    @application = @event_role.applications.build(member: current_member)
    
    respond_to do |format|
      format.js
    end
  end
  
  def create
    @application = EventRoleApplication.new(application_params)
    authorize! :create, @application
    
    if @application.event_role.assigned?
      flash[:error] = "That run position is already filled."
    else
      if params[:notes]
        @notes = params[:notes]
      else
        @notes = nil
      end
      
      @application.save!
      EventRoleApplicationMailer.apply(@application, @notes).deliver_now
      
      flash[:notice] = "Application successfully sent."
    end
    
    redirect_to @application.event_role.event
  end
  
  def confirm
    @application = EventRoleApplication.find(params[:application_id])
    authorize! :update, @application
    
    if @application.event_role.assigned?
      flash[:error] = "That run position is already filled."
    else
      @application.event_role.member = @application.member
      @application.event_role.save!

      EventRoleApplicationMailer.accept(@application).deliver_now
      @application.destroy

      flash[:notice] = "#{@application.event_role.member.display_name} is now #{@application.event_role.description} #{@application.event_role.role}."
    end
    
    redirect_to @application.event_role.event
  end
  
  def deny
    @application = EventRoleApplication.find(params[:application_id])
    authorize! :update, @application
    
    @application.destroy
    
    flash[:notice] = "Application denied."
    
    redirect_to @application.event_role.event
  end
  
  private
    def application_params
      params.require(:event_role_application).permit(:event_role_id, :member_id)
    end
  
end
