class UsersController < ApplicationController
  before_action :set_user, only: [:update, :destroy]
  skip_before_action :authorize_request, only: [:index, :posts, :hacks, :comments]

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
    @bookmarked_hacks = @user.bookmarked_hacks.order(id: :desc)
    @bookmarked_comments = @user.bookmarked_comments.order(id: :desc)
    render json: { comments: @bookmarked_comments, hacks: @bookmarked_hacks }
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
end
