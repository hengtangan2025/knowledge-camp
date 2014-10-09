Explore::Engine.routes.draw do
  root :to => 'index#index'

  resources :topics, :shallow => true do
    collection do
      get :mine
    end

    resources :tutorials, :shallow => true do
      member do
        get :points
      end
      get 'flow' => 'steps#flow'
    end
  end

  resources :tutorials, :shallow => true do
    collection do
      get :mine
    end
    member do
      get :webflow
    end
  end

  resources :points, :shallow => true
end