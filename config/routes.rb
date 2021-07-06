Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'questions#index'

  concern :voteable do
    resource :vote, only: %i[show destroy] do
      post :create, path: ':value', on: :member, as: :new
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy

  resource :user do
    get :rewards, on: :collection
  end

  resources :questions, concerns: :voteable do
    member do
      get :edit
    end
    resources :answers, concerns: :voteable, shallow: true, only: %i[create destroy update] do
      member do
        get :edit
        patch :mark_as_best
      end
    end
  end
end
