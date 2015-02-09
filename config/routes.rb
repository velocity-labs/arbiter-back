Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions' }

  resources :tokens, only: [:index, :show, :create, :update]

  resources :translations, only: [] do
    member do
      get :resolve
    end
  end

  get ':id', to: 'tokens#resolve'
end
