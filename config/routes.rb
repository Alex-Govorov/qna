Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'questions#index'

  resources :attachments, only: :destroy
  resources :links, only: :destroy

  resource :user do
    get :rewards, on: :collection
  end

  # Скорее всего роуты для голосования можно написать более красиво, но не придумал как.
  # Чтобы сохранить урлы вида method/:resource_type/:resource_id как при такой нотации.
  # Моя реализация похожа на API для голосования, видимо и роуты нужно делать соответсвующие
  # Но в API я пока не умею, оставлю пока так.

  post 'vote_up/:resource_type/:resource_id', to: 'votes#vote_up', as: :vote_up
  post 'vote_down/:resource_type/:resource_id', to: 'votes#vote_down', as: :vote_down
  delete 'vote_reset/:resource_type/:resource_id', to: 'votes#vote_reset', as: :vote_reset
  get 'vote_status/:resource_type/:resource_id', to: 'votes#vote_status', as: :vote_status

  resources :questions do
    member do
      get :edit
    end
    resources :answers, shallow: true, only: %i[create destroy update] do
      member do
        get :edit
        patch :mark_as_best
      end
    end
  end
end
