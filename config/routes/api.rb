Fcc::Application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :problems, only: [:show]
    end
  end
end
