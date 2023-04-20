class PostsController < SecuredController
  before_action :set_post, only: [:show, :update, :destroy]
  skip_before_action :authorize_request, only: [:index,:index_with_comments_count, :show_with_user_and_comments, :show, :user]

  def index
    limit = params[:limit]
    query = params[:search]
    if query.present?
      decoded_query = URI.decode_www_form_component(query)
      posts = Post.where("title ILIKE ? OR body ILIKE ?", "%#{decoded_query}%", "%#{decoded_query}%")
    else
      posts = Post.order(id: :desc)
    end
    posts = posts.includes(:user, :comments)
    posts = posts.map do |post|
      {
        id: post.id,
        title: post.title,
        body: post.body,
        user_id: post.user_id,
        created_at: post.created_at,
        name: post.user.name,
        picture: post.user.picture,
        comments_count: post.comments.size
      }
    end
    posts = posts.sort_by { |post| post[:comments_count] }.reverse
    posts = posts.take(limit.to_i) if limit.present?
    render json: posts
  end
  # def index
  #   limit = params[:limit]
  #   query = params[:search]
  #   if query.present?
  #     decoded_query = URI.decode_www_form_component(query)
  #     @posts = Post.where("title LIKE ? OR body LIKE ?", "%#{decoded_query}%", "%#{decoded_query}%")
  #   else
  #     @posts = Post.order(id: :desc)
  #   end
  #   @posts = @posts.limit(limit) if limit.present?
  #   render json: @posts
  # end

  # def index_with_comments_count
  #   @posts = Post.includes(:user, :comments)
  #   posts_with_comments_count = @posts.map do |post|
  #     {
  #       id: post.id,
  #       title: post.title,
  #       body: post.body,
  #       user_id: post.user_id,
  #       created_at: post.created_at,
  #       name: post.user.name,
  #       picture: post.user.picture,
  #       comments_count: post.comments.size
  #     }
  #   end
  #   posts_with_comments_count = posts_with_comments_count.sort_by { |post| post[:comments_count] }.reverse
  #   posts_with_comments_count = posts_with_comments_count.take(params[:limit].to_i) if params[:limit].present?
  #   render json: posts_with_comments_count 
  # end
  
  def show
    render json: { post: @post, name: @post.user.name, picture: @post.user.picture }
  end

  def show_with_user_and_comments
  @post = Post.find(params[:post_id])
  @comments = @post.comments.includes(:user).order(id: :desc)
  render json: @comments.to_json(
    only: [:id, :post_id, :title, :body, :created_at],
    include: {user: {only: [:name, :picture]}}
  )
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
    render json: { error: 'not authorized' }, status: :unauthorized
  end
end

  def destroy
    if @current_user.id == @post.user_id
      @post.destroy
      render json: { message: 'successfully deleted' }, status: :no_content
    else
      render json: { error: 'not authorized' }, status: :unauthorized
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
