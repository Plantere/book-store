Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  
  root to: 'application#index' 

  namespace :api do
    namespace :v1 do
      namespace :webhook do
        post "/" => "stripe#index", as: :webhook_stripe
      end

      post "/register" => "users#register", as: :users_register
      post "/login" => "auth#login", as: :auth_login

      scope '/auth' do
        get "/" => "auth#get_authenticate_profile", as: :get_authenticate_profile
      end

      scope '/user' do
        put "/" => "users#update", as: :user_update
        put "/password" => "users#change_password", as: :user_change_password
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
        put "/default/:address_id" => "addresses#update_default", as: :addresses_update_default
      end

      scope '/genre' do
        get "/" => "genres#index", as: :genres_index
        post "/" => "genres#create", as: :genres_create
        delete "/:genre_id" => "genres#delete", as: :genres_delete
        put "/:genre_id" => "genres#update", as: :genres_update
      end

      scope '/book' do
        get "/search" => "books#search", as: :books_search
        post "/cart" => "books#get_cart_items", as: :books_get_cart_items
        get "/:book_id" => "books#index", as: :books_index
      end

      scope '/admin' do 
        scope '/genre' do
          get '/' => "genres#get_all", as: :admin_genres_get_all 
        end
        
        scope '/publisher' do
          get '/' => "publishers#get_all", as: :admin_publishers_get_all 
        end

        scope '/author' do
          get '/' => "authors#get_all", as: :admin_authors_get_all 
        end

        scope '/order' do
          get '/' => "orders#get_all", as: :admin_orders_get_all 
        end

        scope '/user' do
          get '/' => "users#get_all", as: :admin_users_get_all 
          put '/:user_id' => "users#update_admin", as: :admin_users_update
        end

        scope '/book' do 
          get "/" => "books#get_books", as: :admin_books_get
          put "/:book_id" => "books#update", as: :admin_books_update
          post "/" => "books#create", as: :admin_books_create
        end
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
