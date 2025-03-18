Rails.application.routes.draw do
  devise_for :users, path: '', path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register' }
  
 
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  get '/home', to: "pages#home"
  get '/generate', to: 'attractions#generate'


  resources :attractions, only: [:index, :show]

  post '/checkout', to: 'payments#create_checkout', as: 'create_checkout'
  get '/attractions/:attraction_id/payment_success', to: 'payments#success', as: 'attraction_payment_success'
  resources :itineraries, only: [:index, :show, :new, :create] do
    get '/review', to: 'itineraries#review'
    member do
      post '/update_with_ai', to: 'itineraries#update_with_ai', as: 'update_with_ai'
    end
    post '/fetch_route', to: 'itineraries#fetch_route', as: 'fetch_route'
  end
end
