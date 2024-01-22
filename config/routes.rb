Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  
  namespace :api do
    namespace :v1 do
      post "/register" => "users#register"
      post "/login" => "auth#login"

      scope '/order' do
        post "/" => "orders#create"
        get "/" => "orders#get"
      end


      scope '/address' do
        get "/" => "addresses#get"
        post "/" => "addresses#create"
        delete "/:address_id" => "addresses#delete"
        put "/:address_id" => "addresses#update"
      end

      scope '/telephone' do
        get "/" => "telephones#get"
        post "/" => "telephones#create"
        delete "/:telephone_id" => "telephones#delete"
        put "/:telephone_id" => "telephones#update"
      end

      scope '/genre' do
        get "/" => "genres#index"
        post "/" => "genres#create"
        delete "/:genre_id" => "genres#delete"
        put "/:genre_id" => "genres#update"
      end

      scope '/book' do
        get "/" => "books#index"
        post "/" => "books#create"
        put "/:book_id" => "books#upd ate"
      end

      scope '/publisher' do
        get "/" => "publishers#index"
        post "/" => "publishers#create"
        delete "/:publisher_id" => "publishers#delete"
        put "/:publisher_id" => "publishers#update"
      end

      scope '/author' do
        get "/" => "authors#index"
        post "/" => "authors#create"
        delete "/:author_id" => "authors#delete"
        put "/:author_id" => "authors#update"
      end
    end
  end
  # Defines the root path route ("/")
  # root "posts#index"
end
