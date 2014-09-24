KnowledgeCampApi::Engine.routes.draw do
  resources :nets
  resources :points
  resources :plans
  resources :topics
  resources :tutorials
  resources :steps
  resources :notes
  resources :questions
  resources :learn_records

  match "/*a",
        :to  => "errors#routing",
        :via => %W(get post delete patch head put)
end
