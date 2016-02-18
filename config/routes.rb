Rails.application.routes.draw do

  # api
  #mount KnowledgeCampApi::Engine => '/api'

  ## 学生界面
  #mount Explore::Engine => '/explore'

  ## 课程编辑
  #mount CourseEditor::Engine => '/course_editor'
  # api
  mount KnowledgeCampApi::Engine => '/e/o/api', :as => :e_old_api
  # 学生界面
  mount Explore::Engine          => '/e/o/explore', :as => :e_old_explore
  # 课程编辑
  mount CourseEditor::Engine     => '/e/o/course_editor', :as => :e_old_course_editor

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
  mount QuestionBank::Engine => '/bank/question_bank', :as => 'question_bank'
  FilePartUpload::Routing.mount "/bank/file_part_upload", :as => :file_part_upload
  Bucketerize::Routing.mount '/bank/bucketerize', as: 'bucketerize'
  KcCourses::Routing.mount '/bank/kc_courses', as: :kc_courses
  #EngineManager::Routing.mount '/bank/manager', :as => 'engine_manager'

  # 新版功能的集成代码
  scope :path => "/bank", module: 'bank', :as => :bank do

    root "index#index"
    get '/my_test_questions', to: redirect{'/bank/my_test_questions/records'}
    resources :my_test_questions, module: :teaching do
      get :records, on: :collection
      get :flaw,    on: :collection
      get :fav,     on: :collection
      get :random,  on: :collection

      get  :do_form, on: :member
    end

    resources :my_questions, module: :teaching
    resources :my_answers, module: :teaching
    resources :my_notes, module: :teaching

    resources :courses, module: :teaching do
      get :mine, on: :collection
      get :hot, on: :collection
      get :studying, on: :collection
      get :studied, on: :collection
      get :fav, on: :collection
      get :search, on: :collection
      get :study, on: :member
    end

    resources :notifications do
      get :system, :on => :collection
    end

    # TODO 待梳理后，统一删除
    # get "/dashboard"                       => "dashboard#index"
    # get "/dashboard/courses"               => "dashboard#courses"
    # get "/dashboard/join_courses"          => "dashboard#join_courses"
    # get "/dashboard/fav_courses"           => "dashboard#fav_courses"
    # get "/dashboard/test_questions"        => "dashboard#test_questions"
    # get "/dashboard/test_question_records" => "dashboard#test_question_records"
    # get "/dashboard/flaw_test_questions"   => "dashboard#flaw_test_questions"
    # get "/dashboard/fav_test_questions"    => "dashboard#fav_test_questions"
    # get "/dashboard/questions"             => "dashboard#questions"
    # get "/dashboard/notes"                 => "dashboard#notes"

    scope "test_papers/:test_paper_id", module: :teaching do
      resources :test_paper_results
    end

    scope :path => :manage, module: :manage, :as => :manage do
      resources :courses, module: :teaching, :shallow => true do
        post :publish, on: :member
        resources :course_attachments, :shallow => true
        resources :chapters, :shallow => true do
          member do
            put :move_up
            put :move_down
          end
          resources :wares, :shallow => true do
            member do
              put :move_up
              put :move_down
              get :preview
            end
          end
        end
      end

      resources :test_questions, module: :teaching do
        get :new_single_choice, on: :collection
        get :new_multi_choice, on: :collection
        get :new_bool, on: :collection
        get :new_fill, on: :collection
        get :new_essay, on: :collection
        get :new_mapping, on: :collection
        get :search, on: :collection
      end

      resources :test_papers, module: :teaching, :shallow => true do
        match :preview, on: :collection, via: [:post, :patch]
        post :enable, on: :member
        post :disable, on: :member
      end

      resources :model_labels
    end
  end
end
