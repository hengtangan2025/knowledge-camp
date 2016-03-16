Rails.application.routes.draw do
  # kc mobile 2016 mockup
  get '/' => 'index#index'

  get '/mockup/:page' => 'mockup#page', as: 'mockup'
end
