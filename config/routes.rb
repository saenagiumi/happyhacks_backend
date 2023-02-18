Rails.application.routes.draw do
  resources :comments
  resources :posts do
    resources :comments
  end
  resources :users, param: :sub do
    get 'comments', on: :member
  end
  get 'posts_with_comments_count', to: 'posts#index_with_comments_count'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
