class LikesController < SecuredController
  before_action :set_comment_or_hack, only: [:create]
  skip_before_action :authorize_request, only: [:index]

  def index
    likes_count = Comment.find(params[:comment_id]).likes.size
    render json: { status: :ok, count: likes_count }
  end

  def create
    if params[:comment_id]
      @like = @comment.likes.build(user_id: @current_user.id)
    elsif params[:hack_id]
      @like = @hack.likes.build(user_id: @current_user.id)
    end
    if @like.save
      render json: @like, status: :ok
    else
      render json: @like.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if params[:comment_id]
      comment = Comment.find(params[:comment_id])
      like = comment.likes.find(params[:id])
    elsif params[:hack_id]
      hack = Hack.find(params[:hack_id])
      like = hack.likes.find(params[:id])
    end
    like.destroy
    head :no_content
  end

  private
  def set_comment_or_hack
    if params[:comment_id]
      @comment = Comment.find(params[:comment_id])
    elsif params[:hack_id]
      @hack = Hack.find(params[:hack_id])
    end
  end
end
