Fcc::Application.routes.draw do
  no_create = {except: [:new, :create]}
  no_index = {except: :index}
  devise_for :users

  namespace :user do
    resources :contests, only: [:index, :show] do
      resources :problems, only: [:show] do
      end
    end
    resources :submissions, only: [:index, :create]
  end
end
