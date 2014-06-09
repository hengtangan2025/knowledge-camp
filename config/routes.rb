Rails.application.routes.draw do
  root 'index#index'

  namespace :manage do
    resources :nets, :shallow => true do
      member do
        get :graph
      end

      resources :points, :shallow => true
    end

    resources :users, :shallow => true do
    end
  end

  
  resources :plans, :shallow => true do
    resources :topics do
      resources :tutorials
    end
  end

end
