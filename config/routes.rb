Rails.application.routes.draw do
  resources :plans, :shallow => true do
    resources :topics do
      resources :tutorials
    end
  end

  resources :nets, :shallow => true do
    member do
      get :graph
    end

    resources :knowledge_points
  end

  root 'index#index'
end
