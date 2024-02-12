require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  describe "POST /register" do
    context "with valid data" do
      it "should create user and return success message with status 200 " do
        post "register", params: {user: attributes_for(:user, password: "password_test"), profile: attributes_for(:profile)}
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)).to eq({"message" => "User created successufly"})
      end
    end

    context "with invalid data" do
      it "should return error message for existing email and username with status 422" do
        user = create(:user)
        post "register", params: {user: attributes_for(:user, password: "password_test"), profile: attributes_for(:profile)}
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)).to eq({"error" => "User already registered"})
      end

      it "should return error message for existing email with status 422" do
        user = create(:user)
        post "register", params: {user: attributes_for(:user, username: "dontexist", password: "password_test"), profile: attributes_for(:profile)}
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)).to eq({"error" => "User already registered"})
      end


      it "should return error message for existing username with status 422" do
        user = create(:user)
        post "register", params: {user: attributes_for(:user, email: "dontexist@example.com", password: "password_test"), profile: attributes_for(:profile)}
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)).to eq({"error" => "User already registered"})
      end


      it "should return error message for params without username data with status 422" do
        post "register", params: {user: attributes_for(:user, username: nil, password: "password_test"), profile: attributes_for(:profile)}
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)).to eq({"error" => "Error creating user. Please check the provided data."})
      end

      it "should return error message for params without email data with status 422" do
        post "register", params: {user: attributes_for(:user, email: nil, password: "password_test"), profile: attributes_for(:profile)}
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)).to eq({"error" => "Error creating user. Please check the provided data."})
      end

      it "should return error message for params without password data with status 422" do
        post "register", params: {user: attributes_for(:user, password: nil), profile: attributes_for(:profile)}
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)).to eq({"error" => "Error creating user. Please check the provided data."})
      end

      it "should return error message for params without first_name data with status 422" do
        post "register", params: {user: attributes_for(:user, password: "password_test"), profile: attributes_for(:profile, first_name: nil)}
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)).to eq({"error" => "Error creating user. Please check the provided data."})
      end

      it "should return error message for params without last_name data with status 422" do
        post "register", params: {user: attributes_for(:user, password: "password_test"), profile: attributes_for(:profile, last_name: nil)}
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)).to eq({"error" => "Error creating user. Please check the provided data."})
      end
    end
  end
  
  describe "PUT /user" do
    context "with valid data" do
      it "should update user, return success message with status 200 and user change email" do
        new_user = create(:user)
        profile = create(:profile, user_id: new_user[:id])
        cookies[:token] = JsonWebToken.encode(user_id: new_user[:id])
        put "update", params: {user: attributes_for(:user, email: "changed_email@example.com"), profile: attributes_for(:profile)}
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)).to eq({"message" => "User updated successufly"})
        expect(User.where(email: "changed_email@example.com", id: new_user[:id]).count).to eq(1)
      end
    end

    context "with invalid data" do
      it "should not update user with repeat email and return status 422" do
        new_user = create(:user)
        profile = create(:profile, user_id: new_user[:id])

        user_sam = create(:user, email: "sam@example.com", username: 'sam_example', password_digest: "password_default")
        profile_sam = create(:profile, first_name: "Sam", last_name: "Chris", user_id: user_sam[:id])

        cookies[:token] = JsonWebToken.encode(user_id: new_user[:id])
        put "update", params: {user: attributes_for(:user, email: user_sam[:email]), profile: attributes_for(:profile)}
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)).to eq({"error" => "Email, or username already been used"})
        expect(User.where(email: new_user[:email], id: new_user[:id]).count).to eq(1)
      end

      it "should not update user with repeat username and return status 422" do
        new_user = create(:user)
        profile = create(:profile, user_id: new_user[:id])

        user_sam = create(:user, email: "sam@example.com", username: 'sam_example', password_digest: "password_default")
        profile_sam = create(:profile, first_name: "Sam", last_name: "Chris", user_id: user_sam[:id])

        cookies[:token] = JsonWebToken.encode(user_id: new_user[:id])
        put "update", params: {user: attributes_for(:user, username: user_sam[:username]), profile: attributes_for(:profile)}
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)).to eq({"error" => "Email, or username already been used"})
        expect(User.where(username: new_user[:username], id: new_user[:id]).count).to eq(1)
      end
    end
  end

  describe "GET /users/get_all" do
    it "common user should not be possible get all users and return status 401" do 
      new_user = create(:user)
      cookies[:token] = JsonWebToken.encode(user_id: new_user[:id])
      get "get_all"
      expect(response).to have_http_status(401)
      expect(JSON.parse(response.body)).to eq({"error" => "Access to this resource is restricted to administrators only."})
    end

    it "admin user should get all users and return status 200" do 
      new_user = create(:user, user_type: 2)
      new_profile = create(:profile, user_id: new_user[:id])
      cookies[:token] = JsonWebToken.encode(user_id: new_user[:id])
      get "get_all"
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["data"]).to eq([{
        "id" => new_user[:id],
        "username" => new_user[:username],
        "user_type" => new_user[:user_type],
        "status" => new_user[:status],
        "email" => new_user[:email],
        "profile" => {
          "birth_date" => "2003-02-12",
          "description" => new_profile[:description],
          "first_name" => new_profile[:first_name],
          "last_name" => new_profile[:last_name],
        },
      }])
    end
  end

  describe "PUT /users/update_admin/:user_id" do
    it "common user should not be possible update users and return status 401" do 
      user = create(:user)
    
      user_sam = create(:user, email: "sam@example.com", username: 'sam_example', password_digest: "password_default")
      profile_sam = create(:profile, first_name: "Sam", last_name: "Chris", user_id: user_sam[:id])

      cookies[:token] = JsonWebToken.encode(user_id: user[:id])
    
      get "update_admin", params: {user_id: user_sam[:id], user: {
        email: "changed_email@example.com"
      }, profile: {}}
      expect(response).to have_http_status(401)
      expect(JSON.parse(response.body)).to eq({"error" => "Access to this resource is restricted to administrators only."})
    end

    it "admin should be possible update a user email and return status 200" do 
      admin_user = create(:user, user_type: 2)
    
      user_sam = create(:user, email: "sam@example.com", username: 'sam_example', password_digest: "password_default")
      profile_sam = create(:profile, first_name: "Sam", last_name: "Chris", user_id: user_sam[:id])

      cookies[:token] = JsonWebToken.encode(user_id: admin_user[:id])
    
      get "update_admin", params: {user_id: user_sam[:id], user: {
        email: "changed_email@example.com"
      }}

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq({"message" => "User updated successufly"})
      expect(User.where(email: "changed_email@example.com").count).to eq(1)
    end

    it "admin should be possible update a profile first_name and return status 200" do 
      admin_user = create(:user, user_type: 2)
    
      user_sam = create(:user, email: "sam@example.com", username: 'sam_example', password_digest: "password_default")
      profile_sam = create(:profile, first_name: "Sam", last_name: "Chris", user_id: user_sam[:id])

      cookies[:token] = JsonWebToken.encode(user_id: admin_user[:id])
    
      get "update_admin", params: {user_id: user_sam[:id], profile: {
        first_name: "changed_first_name"
      }}

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq({"message" => "User updated successufly"})
      expect(User.joins(:profile).where(:profile => { :first_name => "changed_first_name" }).count).to eq(1)
    end

    it "admin should not update user with repeat email and return status 422" do
      admin_user = create(:user, user_type: 2)
    
      user_sam = create(:user, email: "sam@example.com", username: 'sam_example', password_digest: "password_default")
      profile_sam = create(:profile, first_name: "Sam", last_name: "Chris", user_id: user_sam[:id])

      user_chris = create(:user, email: "chris@example.com", username: 'anyttto', password_digest: "password_default")
      profile_chris = create(:profile, first_name: "Chris", last_name: "Antony", user_id: user_sam[:id])

      cookies[:token] = JsonWebToken.encode(user_id: admin_user[:id])

      get "update_admin", params: {user_id: user_chris[:id], user: {
        email: "sam@example.com"
      }}

      expect(response).to have_http_status(422)
      expect(JSON.parse(response.body)).to eq({"error" => "Email, or username already been used"})
      expect(User.where(email: user_chris[:email], id: user_chris[:id]).count).to eq(1)
    end

    it "admin should not update user with repeat username and return status 422" do
      admin_user = create(:user, user_type: 2)
    
      user_sam = create(:user, email: "sam@example.com", username: 'sam_example', password_digest: "password_default")
      profile_sam = create(:profile, first_name: "Sam", last_name: "Chris", user_id: user_sam[:id])

      user_chris = create(:user, email: "chris@example.com", username: 'anyttto', password_digest: "password_default")
      profile_chris = create(:profile, first_name: "Chris", last_name: "Antony", user_id: user_sam[:id])

      cookies[:token] = JsonWebToken.encode(user_id: admin_user[:id])

      get "update_admin", params: {user_id: user_chris[:id], user: {
        username: "sam_example"
      }}

      expect(response).to have_http_status(422)
      expect(JSON.parse(response.body)).to eq({"error" => "Email, or username already been used"})
    end


  end

  describe "PUT /password" do
    it "should not logged user change any password and return status 401" do
      put "change_password", params: {password: "12345678@#"}
      expect(response).to have_http_status(401)
      expect(JSON.parse(response.body)).to eq({"error" => "You are not logged in. Please sign in to access the features"})
    end

    it "should user logged change password, and return status 200" do
      user = create(:user)
      cookies[:token] = JsonWebToken.encode(user_id: user[:id])
      put "change_password", params: {password: "12345678@#"}
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq({"error" => "Password changed successufly"})
      user_with_changed_password = User.where(email: user[:email]).first
      expect(user_with_changed_password.authenticate("12345678@#")).to be(user_with_changed_password)
      expect(user_with_changed_password.authenticate("JohnIsAmazing")).not_to be(user_with_changed_password)
    end
  end
end