Rails.application.routes.draw do
  root 'index#index'

  devise_for :users, :skip => :all
  as :user do
    get    "/account/sign_in"  => "sessions#new"
    post   "/account/sign_in"  => "sessions#create"
    delete "/account/sign_out" => "sessions#destroy"
  end

  post "/upload" => "upload#upload"

  namespace :manage do
    resources :nets, :shallow => true do
      member do
        get :graph
      end

      resources :points, :shallow => true
      resources :documents, :shallow => true do
        member do
          get :versions
          get "versions/:version", :to => :version
        end
        # TODO 修改 versions 路由 by ben7th
      end
      resources :files, :shallow => true
    end

    resources :users, :shallow => true do
      resource :avatar, :shallow => true
    end
  end

  resources :plans, :shallow => true do
    resources :topics do
      resources :tutorials
    end
  end

end
