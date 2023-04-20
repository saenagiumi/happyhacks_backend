class HacksController < SecuredController
    before_action :set_hack, only: [:show, :update, :destroy]
    skip_before_action :authorize_request, only: [:index, :likes, :bookmarks, :index_with_comments_count, :show_with_user_and_comments, :show, :user]
  
    def index
      limit = params[:limit]
      query = params[:search]
      @hacks = if query.present?
                decoded_query = URI.decode_www_form_component(query)
                Hack.where("title ILIKE ? OR body ILIKE ?", "%#{decoded_query}%", "%#{decoded_query}%")
               else
                Hack.order(id: :desc)
               end
      @hacks = @hacks.includes(:user, :bookmarks).limit(limit)
      hacks_with_user = @hacks.map do |hack|
        {
          id: hack.id,
          title: hack.title,
          body: hack.body,
          user_id: hack.user_id,
          category: hack.category,
          tags: hack.tags,
          tweet_id: hack.tweet_id,
          created_at: hack.created_at,
          name: hack.user.name,
          picture: hack.user.picture,
          bookmarks_count: hack.bookmarks.size
        }
      end
      hacks_with_user = hacks_with_user.sort_by { |hack| hack[:bookmarks_count] }.reverse
      render json: hacks_with_user
    end

    def likes
      hack = Hack.find(params[:hack_id])
      likes = hack.likes
      likes_count = hack.likes.count
      render json: { status: :ok, likes: likes, likes_count: { status: :ok, count: likes_count} }
    end

    def bookmarks
      hack = Hack.find(params[:hack_id])
      bookmarks = hack.bookmarks
      bookmarks_count = hack.bookmarks.count
      render json: { status: :ok, bookmarks: bookmarks, bookmarks_count: bookmarks_count }
    end
    
    def show
      render json: { hack: @hack, name: @hack.user.name, picture: @hack.user.picture }
    end
  
    def create
      hack = @current_user.hacks.build(hack_params)
  
      if hack.save
        render json: hack
      else
        render json: hack.errors, status: :unprocessable_entity
      end
    end
  
  def update
    if @hack.user == @current_user
      if @hack.update(update_hack_params)
        render json: @hack
      else
        render json: @hack.errors, status: :unprocessable_entity
      end
    else
      render json: { error: 'not authorized' }, status: :unauthorized
    end
  end
  
    def destroy
      if @current_user.id == @hack.user_id
        @hack.destroy
        render json: { message: 'successfully deleted' }, status: :no_content
      else
        render json: { error: 'not authorized' }, status: :unauthorized
      end
    end
  
    private
      def set_hack
        @hack = Hack.find(params[:id])
      end
  
      def hack_params
        params.require(:hack).permit(:title, :body, :user_id, :tweet_id, :category, tags: [])
      end
  
      def update_hack_params
        params.require(:hack).permit(:title, :body, :tweet_id, :category, tags: [])
      end
end
