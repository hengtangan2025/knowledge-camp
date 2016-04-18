def routes_draw(routes_name)
  instance_eval(File.read(Rails.root.join('config', "routes_#{routes_name}.rb")))
end

routes_draw :mockup

Rails.application.routes.draw do
  # -----------------------

  root 'index#index'

  # 老版功能中的集成代码
  devise_for :users, :skip => :all
  as :user do
    get    "/account/sign_in"  => "old/sessions#new"
    post   "/account/sign_in"  => "old/sessions#create"
    delete "/account/sign_out" => "old/sessions#destroy"
  end

  # --------------------
  # 金融学院暂时单独使用 bank 命名空间

  # 文件上传
  mount FilePartUpload::Engine => "/e/file_part_upload", :as => :e_file_part_upload
  # 课程功能
  KcCourses::Routing.mount '/e/kc_courses', as: :e_courses
  #EngineManager::Routing.mount '/bank/manager', :as => 'engine_manager'

  # --------------------
  # kc mobile 2016
  resources :subjects
  resources :courses do
    get "/wares/:ware_id" => "courses#ware", as: :ware
  end

  scope :path => "/api", module: 'api', :as => :api do
    resources :courses do
      post   :add_fav,    on: :member
      delete :remove_fav, on: :member
      post   :comments,   on: :member
    end

    resources :comments

  end

  devise_scope :user do
    get    "/sign_in"      => "sessions#new"
    post   "/api/sign_in"  => "sessions#create"
    delete "/api/sign_out" => "sessions#destroy"

    get    "/sign_up"      => "registrations#new"
    post   "/api/sign_up"  => "registrations#create"
  end

  scope :path => "/manager", module: 'manager', as: :manager do
    get "dashboard" => "dashboard#index"

    resources :courses, shallow: true do
      get :organize, on: :member
      resources :chapters, shallow: true do
        put :move_up,   on: :member
        put :move_down, on: :member
        resources :wares do
          put :move_up,   on: :member
          put :move_down, on: :member
        end
      end
    end

    resources :course_subjects

    resources :published_courses do
      post   :publish, on: :collection
      delete :recall,  on: :collection
    end

    resources :business_categories
    resources :enterprise_posts
    resources :enterprise_levels

    scope :path => '/finance', module: 'finance', as: :finance do
      resources :teller_wares do
        get :screens, on: :collection
        get :trades, on: :collection
        
        get :trade, on: :collection
        get :hmdm, on: :collection
        get :xxdm, on: :collection

        get :design, on: :member
        put :design_update, on: :member
      end
      get '/teller_wares/:number/preview' => "teller_wares#preview", as: :preview

      resources :teller_ware_media_clips do
        get :search, on: :collection
        get :get_infos, on: :collection
      end
    end

  end
end
