class BookmarksController < SecuredController
  before_action :set_comment, only: [:create]
  skip_before_action :authorize_request, only: [:index]

  def index
    comment = Comment.find(params[:comment_id])
    bookmarks = comment.bookmarks
    counts = comment.bookmarks.count
    render json: { status: :ok, bookmarks: bookmarks, counts: counts }
  end

  def show
    @bookmark = @comment.bookmarks.find_by(user_id: params[:id])

    if @bookmark
      render json: { bookmarked: true }
    else
      render json: { bookmarked: false }
    end
  end

  def create
    @bookmark = @comment.bookmarks.build(user_id: @current_user.id)

    if @bookmark.save
      render json: @bookmark, status: :ok
    else
      render json: @bookmark.errors, status: :unprocessable_entity
    end
  end

  def destroy
    comment = Comment.find(params[:comment_id])
    bookmark = comment.bookmarks.find(params[:id])
    bookmark.destroy
    head :no_content
  end

  private
  def set_comment
    @comment = Comment.find(params[:comment_id])
  end
end
