class BookmarksController < SecuredController
  before_action :set_comment_or_hack, only: [:create]
  before_action :authorize_request

  def create
    if params[:comment_id]
      @bookmark = @comment.bookmarks.build(user_id: @current_user.id)
    elsif params[:hack_id]
      @bookmark = @hack.bookmarks.build(user_id: @current_user.id)
    end

    if @bookmark.save
      render json: @bookmark, status: :ok
    else
      render json: @bookmark.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if params[:comment_id]
      comment = Comment.find(params[:comment_id])
      bookmark = comment.bookmarks.find(params[:id])
    elsif params[:hack_id]
      hack = Hack.find(params[:hack_id])
      bookmark = hack.bookmarks.find(params[:id])
    end
    bookmark.destroy
    head :no_content
  end

  private
  def set_comment_or_hack
    if params[:comment_id]
      @comment = Comment.find(params[:comment_id])
    elsif params[:hack_id]
      @hack = Hack.find(params[:hack_id])
    end
  end
end
