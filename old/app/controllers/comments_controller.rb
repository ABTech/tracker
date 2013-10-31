class CommentsController < ApplicationController
  before_filter :login_required
  def create
    @comment = Comment.new(params[:comment])
    @comment.member = current_member
    if @comment.save
      redirect_to event_path(@comment.event)
    else
      render :action => 'new'
    end
  end
  def destroy
    @comment = Comment.find(params[:id])
@comment.current_member=current_member
    event = @comment.event
    if @comment.destroy
      flash[:notice] = 'Comment was deleted!'
    else
      flash[:error] = "Comment wasn't deleted!"
    end
    redirect_to event_path(event)
  end
end
