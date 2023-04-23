class BookmarksController < ApplicationController
  before_action :set_bookmarkable, only: [:create, :destroy]
  before_action :authorize_request

  def create
    @bookmark = @bookmarkable.bookmarks.build(user_id: @current_user.id)
    if @bookmark.save
      render json: @bookmark, status: :ok
    else
      render json: @bookmark.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @bookmark = @bookmarkable.bookmarks.find(params[:id])
    @bookmark.destroy
    head :no_content
  end

  private
  def set_bookmarkable
    @bookmarkable = Comment.find(params[:comment_id]) if params[:comment_id]
    @bookmarkable = Hack.find(params[:hack_id]) if params[:hack_id]
  end
end
