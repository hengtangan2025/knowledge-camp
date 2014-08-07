KnowledgeCampApi::Engine.routes.draw do
  resources :nets
  resources :points
  resources :plans
  resources :topics
  resources :tutorials
  resources :steps
  resources :notes
  resources :learn_records
end
