Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  
  root to: 'application#index' 

  namespace :api do
    namespace :v1 do
      post "/register" => "users#register", as: :users_register
      post "/login" => "auth#login", as: :auth_login

      scope '/auth' do
        get "/" => "auth#get_authenticate_profile", as: :get_authenticate_profile
      end
      scope '/order' do
        post "/" => "orders#create", as: :orders_create
        get "/" => "orders#get", as: :orders_get
      end

      scope '/address' do
        get "/" => "addresses#get", as: :addresses_get
        post "/" => "addresses#create", as: :addresses_create
        delete "/:address_id" => "addresses#delete", as: :addresses_delete
        put "/:address_id" => "addresses#update", as: :addresses_update
      end

      scope '/genre' do
        get "/" => "genres#index", as: :genres_index
        post "/" => "genres#create", as: :genres_create
        delete "/:genre_id" => "genres#delete", as: :genres_delete
        put "/:genre_id" => "genres#update", as: :genres_update
      end

      scope '/book' do
        get "/" => "books#index", as: :books_index
        post "/search" => "books#search", as: :books_search
        post "/" => "books#create", as: :books_create
        put "/:book_id" => "books#update", as: :books_update
      end

      scope '/publisher' do
        get "/" => "publishers#index", as: :publishers_index
        post "/" => "publishers#create", as: :publishers_create
        delete "/:publisher_id" => "publishers#delete", as: :publishers_delete
        put "/:publisher_id" => "publishers#update", as: :publishers_update
      end

      scope '/author' do
        get "/" => "authors#index", as: :authors_index
        post "/" => "authors#create", as: :authors_create
        delete "/:author_id" => "authors#delete", as: :authors_delete
        put "/:author_id" => "authors#update", as: :authors_update
      end
    end
  end

  get '/(*path)', to: 'application#index', as: :application
end
