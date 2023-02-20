class PostsController < SecuredController
  before_action :set_post, only: [:show, :update, :destroy]
  skip_before_action :authorize_request, only: [:index,:index_with_comments_count, :index_with_user_and_comments, :show]

  # GET /posts
  def index
    @posts = User.joins(:posts).select("posts.id, posts.created_at, title, body, name, sub, picture")

    render json: @posts
  end

  def index_with_comments_count
    @posts = Post.joins(:user).select("posts.*, users.name, users.picture, coalesce(count(comments.id), 0) as comments_count").left_joins(:comments).group("posts.id, users.name, users.picture")
    render json: @posts
  end

  def index_with_user_and_comments
    @comments = User.joins(:comments).where("post_id = ?", params[:post_id]).select('comments.id, title, body, name, picture, comments.created_at')

    render json: @comments
  end

  # GET /posts/1
  def show
    render json: {id: @post.id, title: @post.title, body: @post.body, created_at: @post.created_at, sub: @post.user.sub, name: @post.user.name, picture: @post.user.picture, comments_count: @post.comments.count}
  end

  # POST /posts
  def create
    # ユーザー認証
    post = @current_user.posts.build(post_params)

    if post.save
      render json: post
    else
      render json: post.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/1
def update
  if @post.user == @current_user # 現在のユーザーがポストの所有者であるか確認する
    if @post.update(update_post_params)
      render json: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  else
    render json: { error: 'You are not authorized to update this post' }, status: :unauthorized
  end
end

  # DELETE /posts/1
  def destroy
    if @current_user.id == @post.user_id
      @post.destroy
      render json: { message: 'Post successfully deleted' }, status: :no_content
    else
      render json: { error: 'You are not authorized to delete this post' }, status: :unauthorized
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title, :body, :user_id)
    end

    # Only allow a list of trusted parameters through for updating a post
    def update_post_params
      params.require(:post).permit(:title, :body)
    end
end
