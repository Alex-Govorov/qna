Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :questions, only: %i[new show create index] do
    resources :answers, shallow: true, only: %i[new create]
  end
end
