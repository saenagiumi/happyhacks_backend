class PostsController < ApplicationController
  before_action :set_post, only: [:show, :update, :destroy]
  skip_before_action :authorize_request, only: [:index, :show, :user]

  def index
    @posts = if params[:search].present?
      search(params[:search])
    else
      Post.default_order
    end.includes(:user, :comments).limit(params[:limit])

    posts_data = serialize_posts(@posts)
    render json: posts_data
  end
  
  def show
    render json: { post: serialize_post(@post) }
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

    def search(query)
      decoded_query = URI.decode_www_form_component(query)
      Post.where("title ILIKE ? OR body ILIKE ?", "%#{decoded_query}%", "%#{decoded_query}%")
    end

    def serialize_posts(posts)
      posts.map do |post|
        serialize_post(post)
      end.sort_by { |post| -post[:comments_count] }
    end
    
    def serialize_post(post)
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
end
