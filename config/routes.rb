Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  
  namespace :api do
    namespace :v1 do
      post "/register" => "users#register"
      post "/login" => "auth#login"

      scope '/author' do
        get "/" => "authors#index"
        post "/" => "authors#create"
        delete "/:id" => "authors#delete"
      end

      scope '/genre' do
        get "/" => "genres#index"
        post "/" => "genres#create"
        delete "/:id" => "genres#delete"
      end

      scope '/book' do
        get "/" => "books#index"
        post "/" => "books#create"
      end

      scope '/publisher' do
        get "/" => "publishers#index"
        post "/" => "publishers#create"
        delete "/:id" => "publishers#delete"
      end

    end
  end
  # Defines the root path route ("/")
  # root "posts#index"
end
