class PostsController < SecuredController
  before_action :set_post, only: [:show, :update, :destroy]
  skip_before_action :authorize_request, only: [:index,:index_with_comments_count, :show_with_user_and_comments, :show, :user]

  def index
    @posts = Post.all
    render json: @posts
  end

  def index_with_comments_count
    @posts = Post.joins(:user).select("posts.*, users.name, users.picture, coalesce(count(comments.id), 0) as comments_count").left_joins(:comments).group("posts.id, users.name, users.picture")
    render json: @posts
  end
  
  def show
    render json: { post: @post, name: @post.user.name, picture: @post.user.picture }
  end

  def show_with_user_and_comments
    @comments = User.joins(:comments).where("post_id = ?", params[:post_id]).select('comments.id, comments.post_id, title, body, name, picture, comments.created_at')

    render json: @comments
  end

  def create
    post = @current_user.posts.build(post_params)

    if post.save
      render json: post
    else
      render json: post.errors, status: :unprocessable_entity
    end
  end

def update
  if @post.user == @current_user
    if @post.update(update_post_params)
      render json: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  else
    render json: { error: 'You are not authorized to update this post' }, status: :unauthorized
  end
end

  def destroy
    if @current_user.id == @post.user_id
      @post.destroy
      render json: { message: 'Post successfully deleted' }, status: :no_content
    else
      render json: { error: 'You are not authorized to delete this post' }, status: :unauthorized
    end
  end

  private
    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:title, :body, :user_id)
    end

    def update_post_params
      params.require(:post).permit(:title, :body)
    end
end
