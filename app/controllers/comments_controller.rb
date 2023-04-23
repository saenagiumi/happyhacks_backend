class CommentsController < ApplicationController
  before_action :set_comment, only: [:update, :destroy]
  skip_before_action :authorize_request, only: [:index, :likes, :bookmarks]

  def index
    @post = Post.find(params[:post_id])
    @comments = @post.comments.default_order.includes(:user)
    comments_data = serialize_comments(@comments)
    render json: comments_data
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

    def serialize_comments(comments)
      comments.map do |comment|
        serialize_comment(comment)
      end.sort_by { |comment| -comment[:id] }
    end

    def serialize_comment(comment)
      {
        id: comment.id,
        title: comment.title,
        body: comment.body,
        post_id: comment.post_id,
        user_id: comment.user_id,
        created_at: comment.created_at,
        name: comment.user.name,
        picture: comment.user.picture,
      }
    end
end
