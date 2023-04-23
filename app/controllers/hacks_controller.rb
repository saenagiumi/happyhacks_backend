class HacksController < ApplicationController
    before_action :set_hack, only: [:show, :update, :destroy]
    skip_before_action :authorize_request, only: [:index, :likes, :bookmarks, :show]
  
    def index
      @hacks = if params[:search].present?
        search(params[:search])
      else
        Hack.default_order
      end.includes(:user, :bookmarks).limit(params[:limit])
  
      hacks_data = serialize_hacks(@hacks)
      render json: hacks_data
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
      render json: { hack: serialize_hack(@hack) }
    end
  
    def create
      hack = @current_user.hacks.build(hack_params)
  
      if hack.save
        render json: serialize_hack(hack)
      else
        render json: { errors: hack.errors }, status: :unprocessable_entity
      end
    end
  
    def update
      render_not_authorized unless @hack.user == @current_user

      if @hack.update(update_hack_params)
        render json: @hack
      else
        render json: @hack.errors, status: :unprocessable_entity
      end
    end
  
    def destroy
      render_not_authorized unless @hack.user == @current_user
    
      if @hack.destroy
        render json: { message: 'successfully deleted' }, status: :no_content
      else
        render json: { error: 'failed to delete' }, status: :unprocessable_entity
      end
    end
  
    private
      def render_json_template(message=nil, error_message=nil, status=nil)
        render json: { error: error_message, message: message }, status: status
      end

      def set_hack
        @hack = Hack.find(params[:id])
      end
  
      def hack_params
        params.require(:hack).permit(:title, :body, :user_id, :tweet_id, :category, tags: [])
      end
  
      def update_hack_params
        params.require(:hack).permit(:title, :body, :tweet_id, :category, tags: [])
      end

      def search(query)
        decoded_query = URI.decode_www_form_component(query)
        Hack.where("title ILIKE ? OR body ILIKE ?", "%#{decoded_query}%", "%#{decoded_query}%")
      end

      def serialize_hacks(hacks)
        hacks.map do |hack|
          serialize_hack(hack)
        end.sort_by { |hack| -hack[:bookmarks_count] }
      end
      
      def serialize_hack(hack)
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
          bookmarks_count: hack.bookmarks.size,
          likes_count: hack.likes.size
        }
      end
end
