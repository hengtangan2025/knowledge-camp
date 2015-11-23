Rails.application.routes.draw do

  # api
  mount KnowledgeCampApi::Engine => '/api'

  # 学生界面
  mount Explore::Engine => '/explore'

  # 课程编辑
  mount CourseEditor::Engine => '/course_editor'

  # -----------------------

  root 'index#index'

  devise_for :users, :skip => :all
  as :user do
    get    "/account/sign_in"  => "sessions#new"
    post   "/account/sign_in"  => "sessions#create"
    delete "/account/sign_out" => "sessions#destroy"
  end

  namespace :manage do
    resources :nets, :shallow => true do
      member do
        get :graph
      end

      resources :files, :shallow => true

      resources :points, :shallow => true do
        member do
          # TODO 改成体验更好的形式
          get :assign_parent
          get :assign_child
          patch :do_assign
        end

        resources :files, :shallow => true, :controller => :point_files
      end

      resources :documents, :shallow => true do
        resources :versions,
                  :shallow => true,
                  :controller => :document_versions do
          collection do
            get ":version", :action => :version
            post ":version/restore", :action => :restore
          end
        end
      end
      resources :plans, :shallow => true
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

  # -----------------

  namespace :sample do
    resources :nets, :shallow => true do
      resources :tutorials
      resources :students
      resources :points
    end
  end

  # --------------------
  # 金融学院暂时单独使用 bank 命名空间
  FilePartUpload::Routing.mount "/bank/file_part_upload", :as => :file_part_upload
  Bucketerize::Routing.mount '/bank/bucketerize', as: 'bucketerize'
  namespace :bank do
    mount KcCourses::Engine => '/kc_courses'

    root "index#index"
    resources :questions
    resources :qas

    resources :courses do
      get :mine, on: :collection
      get :hot, on: :collection
    end

    resources :notifications do
      get :system, :on => :collection
    end

    get "/dashboard"                       => "dashboard#index"
    get "/dashboard/courses"               => "dashboard#courses"
    get "/dashboard/join_courses"          => "dashboard#join_courses"
    get "/dashboard/fav_courses"           => "dashboard#fav_courses"
    get "/dashboard/test_questions"        => "dashboard#test_questions"
    get "/dashboard/test_question_records" => "dashboard#test_question_records"
    get "/dashboard/flaw_test_questions"   => "dashboard#flaw_test_questions"
    get "/dashboard/fav_test_questions"    => "dashboard#fav_test_questions"
    get "/dashboard/questions"             => "dashboard#questions"
    get "/dashboard/notes"                 => "dashboard#notes"

  end
end
