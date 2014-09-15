Explore::Engine.routes.draw do
  root :to => 'index#index'

  # resources :nets, :shallow => true do
  #   resources :topics, :shallow => true do
  #     resources :tutorials, :shallow => true do
  #       get "steps" => 'steps#index'
  #       get "flow" => 'steps#flow'
  #       get "steps/finish" => 'steps#finish'
  #       get "steps/:num" => 'steps#show'
  #     end
  #   end
  #   resources :points, :shallow => true
  # end

  resources :topics, :shallow => true do
    resources :tutorials, :shallow => true do
      member do
        get :points
      end
      get 'flow' => 'steps#flow'
    end
  end

  resources :points, :shallow => true
end