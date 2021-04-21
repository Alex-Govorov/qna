Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'questions#index'

  resources :questions do
    get :edit, on: :member
    resources :answers, shallow: true, only: %i[create destroy update] do
      get :edit, on: :member
    end
  end
end
