class MemberController < ApplicationController
  before_filter :login_required
  layout "application2"

  before_filter :set_edit_others
  before_filter :set_edit_roles

  private
  def set_edit_others
    @edit_others = current_member.authorized? "member/edit"
    #should this really be a before_filter?
    return true
  end

  def set_edit_roles
    @edit_roles = current_member.authorized? "member/edit_roles"
    return true
  end


  public 
  def list
    @title = "Member List"
    @order = Member.new.has_attribute?(params[:order]) ? params[:order] : Member::Default_sort_key
    if params[:desc] == "1"
      @order += " DESC" 
      @order_desc = true 
    end
    @members = Member.find(:all, :order => @order);
  end

  def show
    @title = "Member Display"

    @member = Member.find(params[:id])
  end

  def new
    @title = "New Member"

    @member = Member.new
  end

  def create
    @member = Member.new(params[:member])
    if @member.save
      flash[:notice] = 'Member was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit_self
    # being used for ACLs

    @title = "Editing Self"
    @member = current_member

    render :action => 'edit'
  end

  def edit
    @title = "Editing Member"
    @member = Member.find(params[:id])
  end

  def update
    if(!current_member().authorized?("/member/edit"))
      @member = current_member();
      params[:member].delete('role_ids')
    else
      @member = Member.find(params[:id])
    end
    if @member.update_attributes(params[:member])
      if @edit_others
        flash[:notice] = 'Member was successfully updated.'
        redirect_to(:action => 'show', :id => @member)
      else
        flash[:notice] = 'Thank you for keeping your information up to date!'
        redirect_to :controller => 'event', :action => 'list'
      end
    else
      render(:action => 'edit')
    end
  end

  def destroy
    Member.find(params[:id]).destroy
    flash[:notice] = 'Member was successfully destroyed.'
    redirect_to(:action => 'list')
  end

  #TODO: settings action doesn't do anything but it's public ... ?
  def settings
    oldsettings = current_member().settings;
    current_member.settings = oldsettings.merge(params.reject{|k, v| k.to_s().index("set") != 0});
  end
end
