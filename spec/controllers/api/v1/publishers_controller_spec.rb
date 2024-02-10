require 'rails_helper'

RSpec.describe Api::V1::PublishersController, type: :controller do
  describe "DELETE /publisher/:publisher_id" do
    it "common user should no access delete publisher route and return status 401" do
      user = create(:user)
      publisher = create(:publisher)
      
      cookies[:token] = JsonWebToken.encode(user_id: user[:id])

      get "delete", params: {publisher_id: publisher[:id]}
      
      expect(response).to have_http_status(401)
      expect(JSON.parse(response.body)).to eq({"error" => "Access to this resource is restricted to administrators only."})
    end

    it "admin user can delete a publisher and return status 200" do
      user = create(:user, user_type: 2)
      publisher = create(:publisher)
      
      cookies[:token] = JsonWebToken.encode(user_id: user[:id])

      get "delete", params: {publisher_id: publisher[:id]}
      
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq({"message" => "Publisher deleted successfully"})
      expect(Publisher.count).to eq(0)
    end

    it "admin user cannot delete user that not exist, and return status 422" do
      user = create(:user, user_type: 2)
      publisher = create(:publisher)
      
      cookies[:token] = JsonWebToken.encode(user_id: user[:id])

      get "delete", params: {publisher_id: publisher[:id]+1}
      
      expect(response).to have_http_status(422)
      expect(JSON.parse(response.body)).to eq({"error" => "Publisher not found"})
      expect(Publisher.count).to eq(1)
    end
  end

  describe "GET /admin/publisher/" do
    it "common user cannot get id, and name of publisher" do
      user = create(:user, user_type: 1)
      publisher = create(:publisher)
      
      cookies[:token] = JsonWebToken.encode(user_id: user[:id])

      get "get_all"
      expect(response).to have_http_status(401)
      expect(JSON.parse(response.body)).to eq({"error" => "Access to this resource is restricted to administrators only."})
    end

    it "should get id, and name of publisher and return status 200" do
      user = create(:user, user_type: 2)
      publisher = create(:publisher)
      
      cookies[:token] = JsonWebToken.encode(user_id: user[:id])

      get "get_all"
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).not_to eq([
        {
          "id" => publisher[:id],
          "name" => publisher[:name],
        }
      ])
    end
  end

  describe "GET /admin/publisher/get" do
    it "common user cannot get all data from publisher" do
      user = create(:user, user_type: 1)
      publisher = create(:publisher)
      
      cookies[:token] = JsonWebToken.encode(user_id: user[:id])

      get "get"
      expect(response).to have_http_status(401)
      expect(JSON.parse(response.body)).to eq({"error" => "Access to this resource is restricted to administrators only."})
    end

    it "should get all data from publisher and return status 200" do
      user = create(:user, user_type: 2)
      publisher = create(:publisher)
      
      cookies[:token] = JsonWebToken.encode(user_id: user[:id])

      get "get"
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["data"]).to eq([
        {
          "id" => publisher.id, 
          "name" => publisher.name, 
          "total_books" => publisher.book.count(), 
          "description" => publisher.description,
        }
      ])
    end
  end

  describe "POST /admin/publisher/" do
    it "common user cannot create a new publisher and return status 401" do
      user = create(:user, user_type: 1)
      publisher = attributes_for(:publisher)
      
      cookies[:token] = JsonWebToken.encode(user_id: user[:id])

      get "create", params: {
        publisher: {
          "name" => publisher[:name],
          "description" => publisher[:description],
        }
      }
      expect(response).to have_http_status(401)
      expect(JSON.parse(response.body)).to eq({"error" => "Access to this resource is restricted to administrators only."})
    end

    it "admin user can create a new publisher and return status 200" do
      user = create(:user, user_type: 2)
      publisher = attributes_for(:publisher)
      
      cookies[:token] = JsonWebToken.encode(user_id: user[:id])

      get "create", params: {
        publisher: {
          "name" => publisher[:name],
          "description" => publisher[:description],
        }
      }
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq({"message" => "Publisher created successfully"})
      expect(Publisher.count).to eq(1)
    end

    it "admin user cannot create a new publisher with duplicate name and return status 422" do
      user = create(:user, user_type: 2)
      publisher = create(:publisher)
      publisher = attributes_for(:publisher, description: "Other description...")
      
      cookies[:token] = JsonWebToken.encode(user_id: user[:id])

      get "create", params: {
        publisher: {
          "name" => publisher[:name],
          "description" => publisher[:description],
        }
      }
      expect(response).to have_http_status(422)
      expect(JSON.parse(response.body)).to eq({"error" => "Publisher already exists"})
      expect(Publisher.count).to eq(1)
    end
  end

  describe "PUT /admin/publisher/:publisher_id" do
    it "common user cannot update a publisher and return status 401" do
      user = create(:user, user_type: 1)
      publisher = create(:publisher)
      
      cookies[:token] = JsonWebToken.encode(user_id: user[:id])

      get "update", params: {
        publisher_id: publisher[:id],
        publisher: {
          "name" => publisher[:name],
          "description" => "other description",
        }
      }

      expect(response).to have_http_status(401)
      expect(JSON.parse(response.body)).to eq({"error" => "Access to this resource is restricted to administrators only."})
      expect(Publisher.where(description: "other description").count).to eq(0)
    end

    it "admin user can update a publisher description and return status 200" do
      user = create(:user, user_type: 2)
      publisher = create(:publisher)
      
      cookies[:token] = JsonWebToken.encode(user_id: user[:id])

      get "update", params: {
        publisher_id: publisher[:id],
        publisher: {
          "name" => publisher[:name],
          "description" => "other description",
        }
      }

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq({"message" => "Publisher updated successfully"})
      expect(Publisher.where(description: "other description").count).to eq(1)
    end

    it "admin user cannot update a publisher that not exist description and return status 422" do
      user = create(:user, user_type: 2)
      publisher = create(:publisher)
      
      cookies[:token] = JsonWebToken.encode(user_id: user[:id])

      get "update", params: {
        publisher_id: publisher[:id]+1,
        publisher: {
          "name" => "somer other name",
          "description" => "other description",
        }
      }

      expect(response).to have_http_status(422)
      expect(JSON.parse(response.body)).to eq({"error" => "Publisher not found"})
      expect(Publisher.where(description: "other description").count).to eq(0)
    end
  end
end