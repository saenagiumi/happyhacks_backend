class LikesController < ApplicationController
  before_action :set_likable, only: [:create, :destroy]
  skip_before_action :authorize_request, only: [:index]

  def index
    likes_count = Comment.find(params[:comment_id]).likes.size
    render json: { status: :ok, count: likes_count }
  end

  def create
    @like = @likable.likes.build(user_id: @current_user.id)
    if @like.save
      render json: @like, status: :ok
    else
      render json: @like.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @like = @likable.likes.find(params[:id])
    @like.destroy
    head :no_content
  end

  private
  def set_likable
    @likable = Comment.find(params[:comment_id]) if params[:comment_id]
    @likable = Hack.find(params[:hack_id]) if params[:hack_id]
  end
end
