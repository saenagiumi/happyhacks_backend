class LikesController < SecuredController
  before_action :set_comment, only: [:create]
  skip_before_action :authorize_request, only: [:index]

  def index
    likes_count = Comment.find(params[:comment_id]).likes.size
    render json: { status: :ok, count: likes_count }
  end

  def create
    @like = @comment.likes.build(user_id: @current_user.id)
    if @like.save
      render json: @like, status: :ok
    else
      render json: @like.errors, status: :unprocessable_entity
    end
  end

  def destroy
    comment = Comment.find(params[:comment_id])
    like = comment.likes.find(params[:id])
    like.destroy
    head :no_content
  end

  private
  def set_comment
    @comment = Comment.find(params[:comment_id])
  end
end
