class KiosksController < ApplicationController
  def index
    authorize! :read, Kiosk
    @title = "Kiosks"
    @kiosks = Kiosk.order("hostname ASC")
  end

  def show
    @kiosk = Kiosk.find(params[:id])
    authorize! :read, @kiosk
    @title = "Viewing Kiosk"
  end

  def new
    authorize! :create, Kiosk
    @title = "New Kiosk"
    @kiosk = Kiosk.new
  end

  def create
    authorize! :create, Kiosk
    @kiosk = Kiosk.new(kiosk_params)
    @kiosk.password = SecureRandom.hex(64)
    if @kiosk.save
      flash[:notice] = 'Kiosk created successfully: ' + @kiosk.password
      redirect_to @kiosk
    else
      render(:action => 'new')
    end
  end

  def edit
    @kiosk = Kiosk.find(params[:id])
    authorize! :update, @kiosk
    @title = "Editing Kiosk"
  end

  def update
    @kiosk = Kiosk.find(params[:id])
    authorize! :update, @kiosk
    if @kiosk.update(kiosk_params)
      flash[:notice] = 'Kiosk updated successfully.'
      redirect_to @kiosk
    else
      render(:action => 'edit')
    end
  end

  def destroy
    @kiosk = Kiosk.find(params[:id])
    authorize! :destroy, @kiosk
    @kiosk.destroy
    flash[:notice] = "Kiosk deleted successfully."
    redirect_to kiosks_url
  end

  def lock
    @kiosk = Kiosk.find(params[:id])
    authorize! :lock, @kiosk
    @kiosk.lock_access!
    flash[:notice] = "Kiosk locked successfully."
    redirect_to @kiosk
  end

  def unlock
    @kiosk = Kiosk.find(params[:id])
    authorize! :unlock, @kiosk
    @kiosk.unlock_access!
    flash[:notice] = "Kiosk unlocked successfully."
    redirect_to @kiosk
  end

  def reset_password
    @kiosk = Kiosk.find(params[:id])
    authorize! :update, @kiosk
    password = SecureRandom.hex(64)
    @kiosk.update_attribute(:password, password)
    flash[:notice] = 'Kiosk updated successfully: ' + password
    redirect_to @kiosk
  end

  private
    def kiosk_params
      params.require(:kiosk).permit(:hostname, :show_header_time, :show_header_network_status, :ability_read_equipment)
    end
end
