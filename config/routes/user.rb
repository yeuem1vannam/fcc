Fcc::Application.routes.draw do
  no_create = {except: [:new, :create]}
  no_index = {except: :index}
  devise_for :users

  namespace :user do
    resources :contests, only: [:index, :show] do
      resources :problems, only: [:show]
      resources :user_scores, only: [:index]
    end
    resources :submissions, only: [:index, :create, :show]
    resources :user_scores, only: [:index]
  end
end
