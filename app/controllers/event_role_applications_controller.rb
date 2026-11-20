class EventRoleApplicationsController < ApplicationController

  def new
    @event_role = EventRole.find_by(id: params[:event_role_id])

    unless @event_role
      flash[:error] = "That run position could not be found."
      redirect_back fallback_location: event_or_index_url
      return
    end

    @application = @event_role.applications.build(member: current_member)
    authorize! :create, @application

    if @event_role.assigned?
      flash[:error] = "That run position is already filled."
      redirect_back fallback_location: @event_role.event
      return
    end

    @title = "Apply for Run Position"
  end

  def withdraw
    @application = EventRoleApplication.find_by(id: params[:application_id])

    unless @application
      flash[:error] = "Role application could not be found."
      redirect_to event_or_index_url
      return
    end

    authorize! :withdraw, @application

    EventRoleApplicationMailer.withdraw(@application).deliver_now
    @application.destroy

    flash[:notice] = "Application withdrawn."

    redirect_to @application.event_role.event
  end

  def create
    @application = EventRoleApplication.new(application_params)
    authorize! :create, @application

    if @application.event_role.nil?
      flash[:error] = "That run position could not be found."
      redirect_to event_or_index_url
      return
    end

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
    @application = EventRoleApplication.find_by(id: params[:application_id])

    if @application
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
    else
      flash[:error] = "Role application could not be found."

      redirect_to events_url
    end
  end

  def deny
    @application = EventRoleApplication.find_by(id: params[:application_id])

    unless @application
      flash[:error] = "Role application could not be found."
      redirect_to event_or_index_url
      return
    end

    authorize! :update, @application

    @application.destroy

    flash[:notice] = "Application denied."

    redirect_to @application.event_role.event
  end

  private
    def event_or_index_url
      event = Event.find_by(id: params[:id])
      event ? event_url(event) : events_url
    end

    def application_params
      params.require(:event_role_application).permit(:event_role_id, :member_id)
    end

end
