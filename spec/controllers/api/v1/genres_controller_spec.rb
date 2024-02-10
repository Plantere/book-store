require 'rails_helper'

RSpec.describe Api::V1::GenresController, type: :controller do
  subject(:admin) { create(:user, user_type: 2) } 
  subject(:client) { create(:user, username: "sam_example", email: "sam@example.com") } 

  describe "POST /admin/genre" do
    it "User with type as a client cannot create genre and status code is 401" do
      attributes_genre = attributes_for(:genre)
      
      cookies[:token] = JsonWebToken.encode(user_id: client[:id])

      post "create", params: {
        genre: {
          name: attributes_genre[:name],
          description: attributes_genre[:description],
        }
      }

      expect(response).to have_http_status(401)
      expect(JSON.parse(response.body)).to eq({"error" => "Access to this resource is restricted to administrators only."})
      expect(Genre.count).to eq(0)
    end

    it "User with type as a admin can create genre and status code is 200" do
      attributes_genre = attributes_for(:genre)

      cookies[:token] = JsonWebToken.encode(user_id: admin[:id])

      post "create", params: {
        genre: {
          name: attributes_genre[:name],
          description: attributes_genre[:description],
        }
      }

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq({"message" => "Genre created successfully"})
      expect(Genre.count).to eq(1)
    end

    it "User with type as a admin cannot create a genre with duplicate name, and status code is 422" do
      genre = create(:genre)
      attributes_genre = attributes_for(:genre, description: "Other description...")

      cookies[:token] = JsonWebToken.encode(user_id: admin[:id])
      
      post "create", params: {
        genre: {
          name: attributes_genre[:name],
          description: attributes_genre[:name]
        }
      }
      expect(response).to have_http_status(422)
      expect(JSON.parse(response.body)).to eq({"error" => "Genre already exists"})
      expect(Genre.where.not(id: genre[:id]).where(name: attributes_genre[:name]).count).to eq(0)
    end
  end

  describe "GET /admin/genre" do
    it "User with type as a client cannot get genre and status code is 401" do
      cookies[:token] = JsonWebToken.encode(user_id: client[:id])
      
      get "get_all"

      expect(response).to have_http_status(401)
      expect(JSON.parse(response.body)).to eq({"error" => "Access to this resource is restricted to administrators only."})
    end

    it "User with type as a admin can get genre and status code is 200" do
      genre = create(:genre)

      cookies[:token] = JsonWebToken.encode(user_id: admin[:id])

      get "get_all"
      
      expect(response).to have_http_status(200)

      response_data = JSON.parse(response.body)["data"]
      expect(response_data).to eq([
        {
          "id" => genre[:id],
          "name" => genre[:name],
        }
      ])
      expect(response_data.count).to eq(1)
    end
  end
  
  describe "PUT /admin/genre/:genre_id" do
    it "User with type as a client cannot update genre and status code is 401" do
      genre = create(:genre)

      cookies[:token] = JsonWebToken.encode(user_id: client[:id])
      
      put "update", params: {
        genre_id: genre[:id],
        genre: {
          name: "Action",
          description: genre[:description],
        }
      }

      expect(response).to have_http_status(401)
      expect(JSON.parse(response.body)).to eq({"error" => "Access to this resource is restricted to administrators only."})
    end

    it "User with type as a admin can update a genre and status code is 200" do
      genre = create(:genre)

      cookies[:token] = JsonWebToken.encode(user_id: admin[:id])

      put "update", params: {
        genre_id: genre[:id],
        genre: {
          name: "Action",
          description: genre[:description],
        }
      }

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq({"message" => "Genre updated successfully"})
      expect(Genre.where(name: "Action").count).to eq(1)
      expect(Genre.where(name: genre[:name]).count).to eq(0)
    end

    it "User with type as a admin can update a genre and status code is 200" do
      genre = create(:genre)

      cookies[:token] = JsonWebToken.encode(user_id: admin[:id])

      put "update", params: {
        genre_id: genre[:id],
        genre: {
          name: "Action",
          description: genre[:description],
        }
      }

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq({"message" => "Genre updated successfully"})
      expect(Genre.where(name: "Action").count).to eq(1)
      expect(Genre.where(name: genre[:name]).count).to eq(0)
    end

    it "User with type as a admin cannot update a genre that not exist and status code is 422" do
      attributes_genre = attributes_for(:genre)

      cookies[:token] = JsonWebToken.encode(user_id: admin[:id])

      put "update", params: {
        genre_id: 1,
        genre: {
          name: attributes_genre[:name],
          description: attributes_genre[:description],
        }
      }

      expect(response).to have_http_status(422)
      expect(JSON.parse(response.body)).to eq({"error" => "Genre not found"})
      expect(Genre.where(name: attributes_genre[:name]).count).to eq(0)
    end

    it "User with type as a admin cannot update a genre without a name and status code is 422" do
      genre = create(:genre)

      cookies[:token] = JsonWebToken.encode(user_id: admin[:id])

      put "update", params: {
        genre_id: genre[:id],
        genre: {
          name: nil,
          description: genre[:description],
        }
      }

      expect(response).to have_http_status(422)
      expect(JSON.parse(response.body)).to eq({"error" => "Failed to updated genre. Please check the provided data."})
      expect(Genre.where(name: genre[:name]).count).to eq(1)
    end

    it "User with type as a admin cannot update a genre without a description and status code is 422" do
      genre = create(:genre)

      cookies[:token] = JsonWebToken.encode(user_id: admin[:id])

      put "update", params: {
        genre_id: genre[:id],
        genre: {
          name: genre[:name],
          description: nil,
        }
      }

      expect(response).to have_http_status(422)
      expect(JSON.parse(response.body)).to eq({"error" => "Failed to updated genre. Please check the provided data."})
      expect(Genre.where(id: genre[:id], description: genre[:description]).count).to eq(1)
    end
    
  end

  describe "DELETE /admin/genre/:genre_id" do
    it "User with type as a client cannot delete a genre and status code is 401" do
      genre = create(:genre)

      cookies[:token] = JsonWebToken.encode(user_id: client[:id])

      get "delete", params: { genre_id: genre[:id] }

      expect(response).to have_http_status(401)
      expect(JSON.parse(response.body)).to eq({"error" => "Access to this resource is restricted to administrators only."})
    end

    it "User with type as a admin can delete a genre and status code is 200" do
      genre = create(:genre)

      cookies[:token] = JsonWebToken.encode(user_id: admin[:id])

      get "delete", params: { genre_id: genre[:id] }

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq({"message" => "Genre deleted successfully"})
    end

    it "User with type as a admin cannot delete a genre that not exist and status code is 422" do
      cookies[:token] = JsonWebToken.encode(user_id: admin[:id])

      get "delete", params: { genre_id: 1 }

      expect(response).to have_http_status(422)
      expect(JSON.parse(response.body)).to eq({"error" => "Genre not found"})
    end
    
  end
end