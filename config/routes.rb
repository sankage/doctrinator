Rails.application.routes.draw do
  resources :players, only: [:index, :show, :new, :create, :destroy] do
    resources :api_keys, only: [:new, :create, :show, :destroy] do
      member do
        post "import"
      end
    end
    resources :pilots, only: [:show] do
      member do
        get "import_skills"
        patch "mark_prime"
        patch "make_generic"
        patch "make_fc"
        patch "make_admin"
      end
    end
  end

  resources :api_keys, only: [:index]

  resources :fittings, only: [:index, :show, :new, :create]
  resources :doctrines, only: [:index, :show, :new, :create, :edit, :update]

  get    'login'   => 'sessions#new'
  delete 'logout'  => 'sessions#destroy'
  get '/auth/:provider/callback' => 'sessions#create'
end
