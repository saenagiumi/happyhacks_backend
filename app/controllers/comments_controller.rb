class CommentsController < SecuredController
  before_action :set_comment, only: [:update, :destroy]
  skip_before_action :authorize_request, only: [:index, :likes, :bookmarks]

  def index
    post = Post.find(params[:post_id])
    comments = post.comments
    render json: comments
  end

  def likes
    post = Post.find(params[:post_id])
    comment = post.comments
    likes = comment.find(params[:comment_id]).likes
    render json: { status: :ok, likes: likes }
  end
  
  def bookmarks
    post = Post.find(params[:post_id])
    comment = post.comments
    bookmarks = comment.find(params[:comment_id]).bookmarks
    render json: { status: :ok, bookmarks: bookmarks }
  end

  def create
    comment = @current_user.comments.build(comment_params)
    if comment.save
      render json: comment
    else
      render json: comment.errors, status: :unprocessable_entity
    end
  end

  def update
    if @comment.user == @current_user
      if @comment.update(update_comment_params)
        render json: @comment
      else
        render json: @comment.errors, status: :unprocessable_entity
      end
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  def destroy
    @comment.destroy
  end

  private
    def set_comment
      @comment = Comment.find(params[:id])
    end

    def comment_params
      params.require(:comment).permit(:title, :body, :post_id, :user_id)
    end

    def update_comment_params
      params.require(:comment).permit(:title, :body)
    end
end
