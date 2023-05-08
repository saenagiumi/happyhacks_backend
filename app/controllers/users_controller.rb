class UsersController < ApplicationController
  before_action :set_user, only: [:update, :destroy]
  skip_before_action :authorize_request, only: [:index, :posts, :hacks, :comments, :bookmarks]

  def show
    @user = User.find_by(sub: params[:sub])
    render json: @user
  end

  def posts
    @user = User.find(params[:id])
    @posts = @user.posts.order(id: :desc)
    render json: @posts
  end

  def hacks
    @user = User.find(params[:id])
    @hacks = @user.hacks.order(id: :desc)
    render json: @hacks
  end
  
  def comments
    @user = User.find(params[:id])
    @comments = @user.comments.order(id: :desc)
    render json: @comments
  end
  
  def bookmarks
    @user = User.find(params[:id])
    @bookmarks = @user.bookmarks
    bookmarks_data = {
      hacks: serialize_bookmarks(@bookmarks.where.not(hack_id: nil)),
      comments: serialize_bookmarks(@bookmarks.where.not(comment_id: nil))
    }
    render json: bookmarks_data
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :ok, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:sub, :name, :picture)
    end

    def serialize_bookmarks(bookmarks)
      bookmarks.map do |bookmark|
        serialize_bookmark(bookmark)
      end
    end

    def serialize_bookmark(bookmark)
      if bookmark.comment.present?
        {
          id: bookmark.comment.id,
          post_id: bookmark.comment.post.id,
          title: bookmark.comment.title,
          body: bookmark.comment.body,
          status: bookmark.status
        }
      elsif bookmark.hack.present?
        {
          id: bookmark.hack.id,
          title: bookmark.hack.title,
          body: bookmark.hack.body,
          status: bookmark.status
        }
      end
    end
end
