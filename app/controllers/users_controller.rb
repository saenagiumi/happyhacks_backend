class UsersController < SecuredController
  before_action :set_user, only: [:update, :destroy]
  skip_before_action :authorize_request, only: [:index,:show,:comments, :bookmarks, :check_first_access]

  # GET /users
  def index
    @users = User.all

    render json: @users
  end

  # GET /users/1
  def show
    @user = User.find_by(sub: params[:sub])
    render json: @user
  end
  
  # GET /users/id/comments
  def comments
    @user = User.find(params[:id])
    @comments = @user.comments
    render json: @comments
  end

  # GET /users/1/bookmark
  def bookmarks
    @user = User.find(params[:id])
    @bookmarked_comments = @user.bookmarked_comments
    render json: @bookmarked_comments
  end

  # 初回アクセスかどうかを判断するエンドポイント
  def check_first_access
    user = User.find_by(email: params[:email])
    if user
      render json: { is_first_access: false }
    else
      render json: { is_first_access: true }
    end
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :ok, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:sub, :name, :email, :picture)
    end
end
