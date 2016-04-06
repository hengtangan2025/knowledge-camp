Rails.application.routes.draw do
  # ------------------
  # kc mobile 2016 mockup
  get     '/mockup/:page' => 'mockup#page', as: 'mockup'
  post    '/mockup/:req'  => 'mockup#do_post', as: 'mockup_post'
  delete  '/mockup/:req'  => 'mockup#do_delete', as: 'mockup_delete'

  get     '/mockup/auth/:page' => 'mockup#auth_page', as: 'mockup_auth'
  post    '/mockup/auth/:req'  => 'mockup#auth_do_post', as: 'mockup_auth_post'
  delete  '/mockup/auth/:req'  => 'mockup#auth_do_delete', as: 'mockup_auth_delete'

  get     '/mockup/manager/:page' => 'mockup#manager_page', as: 'mockup_manager'
  post    '/mockup/manager/:req'  => 'mockup#manager_do_post', as: 'mockup_manager_post'
  put     '/mockup/manager/:req'  => 'mockup#manager_do_put', as: 'mockup_manager_put'
  delete  '/mockup/manager/:req'  => 'mockup#manager_do_delete', as: 'mockup_manager_delete'

  get     '/mockup/manager/bank/:page' => 'mockup#manager_bank_page', as: 'mockup_manager_bank'
end