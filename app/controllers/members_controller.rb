class MembersController < ApplicationController
  load_and_authorize_resource :except => :create
  
  def index
    @title = "Member List"
    @order = Member.new.has_attribute?(params[:order]) ? params[:order] : Member::Default_sort_key
    if params[:desc] == "1"
      @order += " DESC" 
      @order_desc = true 
    end

    @members = @members.order(@order)

    respond_to do |format|
      format.html
      format.vcf { render :layout => false }
    end
  end

  def show
    @title = "Member Display"

    respond_to do |format|
      format.html
      format.vcf { render :layout => false }
    end
  end

  def new
    @title = "New Member"
  end

  def create
    @member = Member.new(member_params)
    authorize! :create, @member
    
    if @member.save
      flash[:notice] = 'Member was successfully created.'
      redirect_to members_path
    else
      render :action => 'new'
    end
  end

  def edit
    @title = "Editing Member"
  end

  def update
    if @member.update_attributes(member_params)
      if can? :show, Member
        flash[:notice] = 'Member was successfully updated.'
        redirect_to(:action => 'show', :id => @member)
      else
        flash[:notice] = 'Thank you for keeping your information up to date!'
        redirect_to :controller => 'events', :action => 'index'
      end
    else
      render(:action => 'edit')
    end
  end

  def destroy
    @member.destroy
    flash[:notice] = 'Member was successfully destroyed.'
    redirect_to members_path
  end
  
  def tshirts
    @title = "T-Shirt Sizes"

    @shirt_sizes = @members.active.group_by(&:shirt_size)
  end
  
  private
    def member_params
      if params[:member][:password].blank?
        params[:member].delete(:password)
        params[:member].delete(:password_confirmation)
      end
      
      if params[:member][:role] and (not current_member.is_at_least? params[:member][:role] or cannot? :manage, Member)
        params[:member].delete(:role)
      end
      
      if cannot? :manage, :finance
        params[:member].delete(:payrate)
      end
      
      params.require(:member).permit(:password, :password_confirmation, :email, :namefirst, :namelast, :namenick, :title, :callsign, :shirt_size, :phone, :aim, :ssn, :payrate, :role)
    end
end
