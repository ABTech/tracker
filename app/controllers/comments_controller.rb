class CommentsController < ApplicationController
  before_filter :authenticate_member!

  def create
    @event = Event.find(params[:comment][:event_id])
    @comment = @event.comments.build(comment_params)
    @comment.member = current_member
    if @comment.save
      flash[:notice] = "Comment was created successfully!"
    else
      flash[:error] = "Comment could not be created (make sure you actually entered text!)."
    end
    
    redirect_to event_path(@comment.event)
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
  
  private
    def comment_params
      params.require(:comment).permit(:content)
    end
end
