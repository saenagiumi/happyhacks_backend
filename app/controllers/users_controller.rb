class UsersController < SecuredController
  before_action :set_user, only: [:update, :destroy]
  skip_before_action :authorize_request, only: [:index, :posts, :comments, :bookmarks]

  def show
    @user = User.find_by(sub: params[:sub])
    render json: @user
  end

  def posts
    @user = User.find(params[:id])
    @posts = @user.posts
    render json: @posts
  end
  
  def comments
    @user = User.find(params[:id])
    @comments = @user.comments
    render json: @comments
  end

  def bookmarks
    @user = User.find(params[:id])
    @bookmarked_comments = @user.bookmarked_comments
    render json: @bookmarked_comments
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
