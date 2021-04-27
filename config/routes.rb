Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'questions#index'

  resources :questions do
    member do
      get :edit
      delete :delete_attachment
    end
    resources :answers, shallow: true, only: %i[create destroy update] do
      member do
        get :edit
        patch :mark_as_best
        delete :delete_attachment
      end
    end
  end
end
