Rails.application.routes.draw do
  # kc mobile 2016 mockup
  get '/' => 'index#index'

  get     '/mockup/:page' => 'mockup#page', as: 'mockup'
  post    '/mockup/:req' => 'mockup#do_post', as: 'mockup_post'
  delete  '/mockup/:req' => 'mockup#do_delete', as: 'mockup_delete'
end
