Explore::Engine.routes.draw do
  root :to => 'index#index'

  resources :nets, :shallow => true do
    resources :tutorials, :shallow => true do
      get "steps/:num" => 'steps#show'
    end
    resources :points, :shallow => true
  end
end