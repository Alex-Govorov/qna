Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'questions#index'

  resources :questions, only: %i[new show create index destroy] do
    resources :answers, only: %i[new create destroy]
  end
end
