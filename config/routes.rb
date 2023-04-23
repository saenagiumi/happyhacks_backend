Rails.application.routes.draw do
  resources :hacks do
    resources :likes, only: [:create, :destroy]
    resources :bookmarks, only: [:create, :destroy]
  end
  get '/hacks/:hack_id/likes', to: 'hacks#likes'
  get '/hacks/:hack_id/bookmarks', to: 'hacks#bookmarks'
  resources :comments, only: [:update, :destroy] do
    resources :likes, only: [:index, :create, :destroy]
    resources :bookmarks, only: [:create, :destroy]
  end
  get '/posts/:post_id/comments/:comment_id/likes', to: 'comments#likes'
  get '/posts/:post_id/comments/:comment_id/bookmarks', to: 'comments#bookmarks'
  resources :posts do
    resources :comments, only: [:index, :create]
  end
  resources :users, only: [:create, :show, :update] do
    get 'posts', on: :member
    get 'hacks', on: :member
    get 'comments', on: :member
    get 'bookmarks', on: :member
  end
end
