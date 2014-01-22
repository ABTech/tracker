class RolesController < ApplicationController
  
  before_filter :authenticate_member!;

  def index
    @title = "Listing Roles"
    @roles = Role.order("id ASC").all
  end

  def show
    @title = "Role View"

    @role = Role.find(params[:id])
  end

  def new
    @title = "Creating Role"

    @role = Role.new
  end

  def create
    @role = Role.new(params[:role])
    if @role.save
      flash[:notice] = 'Role was successfully created.'
      redirect_to roles_url
    else
      render :action => 'new'
    end
  end

  def edit
    @title = "Editing Role"

    @role = Role.find(params[:id]);
  end

  def update
    @role = Role.find(params[:id])
    if @role.update_attributes(params[:role])
      flash[:notice] = 'Role was successfully updated.'
      redirect_to(@role)
    else
      render(:action => 'edit')
    end
  end

  def destroy
    Role.find(params[:id]).destroy
    redirect_to roles_url
  end
end
