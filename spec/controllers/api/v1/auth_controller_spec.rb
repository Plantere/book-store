require 'rails_helper'

RSpec.describe Api::V1::AuthController, type: :controller do
  subject(:user) { create(:user) } 

  describe "POST /login" do
    it "User cannot be possible login with password wrong, and status code is 401" do
      post "login", params: {
        email: user[:email],
        password: "wrong_password",
      }

      expect(response).to have_http_status(401)
      expect(JSON.parse(response.body)).to eq({"error" => "Incorrect email or password. Please check your credentials and try again."})
    end
    
    it "User cannot be possible login with email wrong, and status code is 401" do
      post "login", params: {
        email: "wrong_email@example.com",
        password: "JohnIsAmazing",
      }

      expect(response).to have_http_status(401)
      expect(JSON.parse(response.body)).to eq({"error" => "Incorrect email or password. Please check your credentials and try again."})
    end

    it "User cannot be possible login without filling email, and status code is 401" do
      post "login", params: {
        password: "JohnIsAmazing",
      }

      expect(response).to have_http_status(401)
      expect(JSON.parse(response.body)).to eq({"error" => "Incorrect email or password. Please check your credentials and try again."})
    end

    it "User cannot be possible login without filling password, and status code is 401" do
      post "login", params: {
        email: user[:email],
      }

      expect(response).to have_http_status(401)
      expect(JSON.parse(response.body)).to eq({"error" => "Incorrect email or password. Please check your credentials and try again."})
    end

    it "Use can login with email, and password correct, and status code is 200" do
      post "login", params: {
        email: user[:email],
        password: "JohnIsAmazing",
      }
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to have_key("token")
    end
  end

  describe "GET /auth" do
    it "User not authenticated cannot be possible get authenticate profile data, and status code is 401" do
      get "get_authenticate_profile"
      
      expect(response).to have_http_status(401)
      expect(JSON.parse(response.body)).to eq({"error" => "You are not logged in. Please sign in to access the features"})
    end

    it "User authenticated can get authenticate profile data, and status code is 200" do 
      create(:profile, user_id: user[:id])
      cookies[:token] = JsonWebToken.encode(user_id: user[:id])

      get "get_authenticate_profile"
      expect(response).to have_http_status(200)
    end
  end
end