class AttachmentsController < ApplicationController
  load_and_authorize_resource
  
  # GET /attachments/
  def index
    @title = "Attachments List"

    respond_to do |format|
      format.html
    end
  end

  # DELETE /attachments/
  def destroy
    @attachment.destroy

    respond_to do |format|
      flash[:notice] = "Attachment has been deleted."
      format.html { redirect_to request.referer }
    end
  end
end
