Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "static_pages#home"

  # Static Pages
  get "hire-me", to: "static_pages#hire_me"
  get "about", to: "static_pages#about"

  # Learning Resources (only index, new, create)
  resources :learnings, only: [:index, :new, :create] do
    delete :destroy_multiple, on: :collection
  end

  # Optional: If you need a dedicated path for the TIL list besides /tils
  # get "/tils", to: "tils#index", as: :til_list
end
