Rails.application.routes.draw do
  resources :plans, :shallow => true do
    resources :topics do
      resources :tutorials
    end
  end

  resources :knowledge_nets do
    resources :knowledge_points
  end
end
