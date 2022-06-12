class KiosksController < ApplicationController
  def index
    authorize! :read, Kiosk
    @title = "Kiosks"
    @kiosks = Kiosk.order("hostname ASC")
  end

  def show
    authorize! :read, @kiosk
    @title = "Viewing Kiosk"
    @kiosk = Kiosk.find(params[:id])
  end

  def new
    authorize! :create, @kiosk
    @title = "New Kiosk"
    @kiosk = Kiosk.new
  end

  def create
    authorize! :create, @kiosk
    @kiosk = Kiosk.new(kiosk_params)
    @kiosk.password = SecureRandom.hex(64)
    if @kiosk.save
      flash[:notice] = 'Kiosk was successfully created: ' + @kiosk.password
      redirect_to @kiosk
    else
      render(:action => 'new')
    end
  end

  def edit
    authorize! :update, @kiosk
    @title = "Editing Kiosk"
  end

  def update
    authorize! :update, @kiosk
    @kiosk = Kiosk.find(params[:id])
    if @kiosk.update(kiosk_params)
      flash[:notice] = 'Kiosk was successfully updated.'
      redirect_to @kiosk
    else
      render(:action => 'edit')
    end
  end

  def destroy
    authorize! :destroy, @kiosk
    @kiosk.destroy
    flash[:notice] = "Kiosk deleted successfully."
    redirect_to kiosks_url
  end

  def lock
    authorize! :update, @kiosk
    @kiosk.lock_access!
    flash[:notice] = "Kiosk locked successfully."
    redirect_to @kiosk
  end

  def unlock
    authorize! :update, @kiosk
    @kiosk.unlock_access!
    flash[:notice] = "Kiosk unlocked successfully."
    redirect_to @kiosk
  end

  def reset_password
    authorize! :update, @kiosk
    password = SecureRandom.hex(64)
    @kiosk.update_attribute(:password, password)
    flash[:notice] = 'Kiosk was successfully updated: ' + password
    redirect_to @kiosk
  end

  private
    def kiosk_params
      params.require(:kiosk).permit(:hostname)
    end
end
