class PostsController < SecuredController
  before_action :set_post, only: [:show, :update, :destroy]
  skip_before_action :authorize_request, only: [:index,:index_with_comments_count,:show]

  # GET /posts
  def index
    @posts = User.joins(:posts).select("posts.id, posts.created_at, title, body, name, sub, picture")

    render json: @posts
  end

  def index_with_comments_count
    @posts = Post.joins(:user).select("posts.*, users.name, users.picture, coalesce(count(comments.id), 0) as comments_count").left_joins(:comments).group("posts.id, users.name, users.picture")
    render json: @posts
  end

  # GET /posts/1
  def show
    render json: {id: @post.id, title: @post.title, body: @post.body, created_at: @post.created_at, name: @post.user.name, comments_count: @post.comments.count}
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
    if @post.update(post_params)
      render json: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1
  def destroy
    @post.destroy
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
end
