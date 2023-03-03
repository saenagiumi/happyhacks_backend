Rails.application.routes.draw do
  resources :comments do
    resources :bookmarks, only: [:index, :create, :destroy]
    resources :likes, only: [:index, :create, :destroy, :show]
  end
  resources :posts do
    resources :comments
    get 'user', on: :member, to: 'posts#user'
    get 'comments_with_user', to: 'posts#index_with_user_and_comments'
  end
  resources :users do
    get 'comments', on: :member
    get 'bookmarks', on: :member
  end
  get 'posts_with_comments_count', to: 'posts#index_with_comments_count'
  # コメントを検索するためのルーティングを追加
  resources :users, param: :sub do
    get 'comments', to: 'users#comments'
  end
  # 初回アクセスかどうかをチェックするためのルーティング
  # get 'check_first_access/', to: 'users#check_first_access', as: 'check_first_access'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
