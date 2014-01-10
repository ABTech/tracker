class AttachmentsController < ApplicationController

  # GET /attachments/
  def index
    @title = "Attachments List"

    @attachments = Attachment.find(:all)

    respond_to do |format|
      format.html
    end
  end

  # DELETE /attachments/
  def destroy
    @attachment = Attachment.find(params[:id])

    @attachment.destroy

    respond_to do |format|
      flash[:notice] = "Attachment has been deleted."
      format.html { redirect_to request.referer }
    end
  end
end
