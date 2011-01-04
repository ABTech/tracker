class RoleController < ApplicationController
    before_filter :login_required;

    def list
        @title = "Listing Roles"
        @roles = Role.find(:all)
    end

    def view
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
            redirect_to :action => 'list'
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
            redirect_to(:action => 'list', :id => @role)
        else
            render(:action => 'edit')
        end
    end

    def destroy
        Role.find(params[:id]).destroy
        redirect_to(:action => 'list')
    end
end
