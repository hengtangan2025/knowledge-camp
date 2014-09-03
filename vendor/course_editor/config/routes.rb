CourseEditor::Engine.routes.draw do
  root 'index#index'

  resources :nets, :shallow => true do
    resources :topics, :shallow => true do
      resources :tutorials, :shallow => true do
        resources :steps, :shallow => true do
          member do
            put :update_continue
            put :update_title
          end
        end
      end
    end
  end
end