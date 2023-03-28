class BookmarksController < SecuredController
  before_action :set_comment, only: [:create]
  before_action :authorize_request

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
