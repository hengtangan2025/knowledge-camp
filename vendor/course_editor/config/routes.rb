CourseEditor::Engine.routes.draw do
  root 'index#index'

  resources :nets, :shallow => true do
    resources :topics, :shallow => true do
      resources :tutorials, :shallow => true do
        member do
          get :design
        end

        resources :steps, :shallow => true do
          member do
            put :update_continue
            put :update_title
            
            put :add_content
            get :load_content
            delete :delete_content
            put :update_content
          end
        end
      end
    end
  end
end