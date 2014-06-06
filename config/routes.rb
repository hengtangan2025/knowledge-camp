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

  devise_for :users, :skip => :all
  as :user do
    get    "/account/sign_in"  => "sessions#new"
    post   "/account/sign_in"  => "sessions#create"
    delete "/account/sign_out" => "sessions#destroy"
  end

end
