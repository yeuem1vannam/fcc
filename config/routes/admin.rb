Fcc::Application.routes.draw do
  no_create = {except: [:new, :create]}
  no_index = {except: :index}
  devise_for :admins

  namespace :admin do
    resources :admins
    root to: "admins#index"
  end

end
