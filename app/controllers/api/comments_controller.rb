class Api::CommentsController < ApplicationController
  before_action :authenticated_user!, only: :create
  
  def index
    episode = Episode.find params[:episode_id]
    render json: episode.comments.order("created_at DESC").to_json(include: :user)
  end
  
  def create
    @comment = current_user.comments.build comment_params
    if @comment.save
      render json: @comment.to_json(include: :user)
    else
      raise Errors::UnprocessableEntity
    end
  end
  
  private
  
  def comment_params
    params.require(:comment).permit :body, :episode_id
  end
end
