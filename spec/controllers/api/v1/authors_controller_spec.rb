require 'rails_helper'

RSpec.describe Api::V1::AuthorsController, type: :controller do
  subject(:admin) { create(:user, user_type: 2) } 
  subject(:client) { create(:user, username: "sam_example", email: "sam@example.com") } 

  describe "GET /admin/author/" do
    it "User with type as a client cannot get all authors and status code is 401" do
      cookies[:token] = JsonWebToken.encode(user_id: client[:id])
      
      get "get_all"
      
      expect(response).to have_http_status(401)
      expect(JSON.parse(response.body)).to eq({"error" => "Access to this resource is restricted to administrators only."})
    end
    
    it "User with type as a admin can get all authors and status is 200" do
      author = create(:author)

      cookies[:token] = JsonWebToken.encode(user_id: admin[:id])

      get "get_all"

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq({
        "data" => [
          {
            "id" => author[:id],
            "full_name" => author[:full_name]
          }
        ]
      })
    end
  end
  
  describe "GET /admin/author/get/" do
    it "User with type as a client cannot get all authors with pagination and status code is 401" do
      cookies[:token] = JsonWebToken.encode(user_id: client[:id])
      
      get "get"

      expect(response).to have_http_status(401)
      expect(JSON.parse(response.body)).to eq({"error" => "Access to this resource is restricted to administrators only."})
    end

    it "User with type as a admin can get all authors with pagination and status code is 200" do
      cookies[:token] = JsonWebToken.encode(user_id: admin[:id])

      get "get"

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to have_key("pagination")
      expect(JSON.parse(response.body)).to have_key("data")
    end

  end

  describe "POST /admin/author/" do
    it "User with type as a client cannot create a new author and status code is 401" do
      attributes_author = attributes_for(:author)
      cookies[:token] = JsonWebToken.encode(user_id: client[:id])
      
      post "create", params: {
        author: {
          full_name: attributes_author[:full_name],
          biography: attributes_author[:biography],
          birth_date: attributes_author[:birth_date],
        }
      }

      expect(response).to have_http_status(401)
      expect(JSON.parse(response.body)).to eq({"error" => "Access to this resource is restricted to administrators only."})
    end

    it "User with type as a admin can create a new author and status code is 200" do
      attributes_author = attributes_for(:author)

      cookies[:token] = JsonWebToken.encode(user_id: admin[:id])

      post "create", params: {
        author: {
          full_name: attributes_author[:full_name],
          biography: attributes_author[:biography],
          birth_date: attributes_author[:birth_date],
        }
      }
      
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq({"message" => "Author created successfully"})
      expect(Author.where(full_name: attributes_author[:full_name]).count).to eq(1)
    end

    it "User with type as a admin cannot create a new author without full_name and status code is 422" do
      attributes_author = attributes_for(:author)

      cookies[:token] = JsonWebToken.encode(user_id: admin[:id])

      post "create", params: {
        author: {
          biography: attributes_author[:biography],
          birth_date: attributes_author[:birth_date],
        }
      }

      expect(response).to have_http_status(422)
      expect(JSON.parse(response.body)).to eq({"error" => "Failed to create author. Please check the provided data."})
      expect(Author.where(biography: attributes_author[:biography]).count).to eq(0)
    end

    it "User with type as a admin cannot create a duplicate author and status code is 422" do
      author = create(:author)

      cookies[:token] = JsonWebToken.encode(user_id: admin[:id])

      post "create", params: {
        author: {
          full_name: author[:full_name],
          biography: author[:biography],
          birth_date: author[:birth_date],
        }
      }

      expect(response).to have_http_status(422)
      expect(JSON.parse(response.body)).to eq({"error" => "Author already exists"})
      expect(Author.where(full_name: author[:full_name]).count).to eq(1)
    end
  end

  describe "PUT /admin/author/:author_id" do
    it "User with type as a client cannot update a author and status code is 401" do
      author = create(:author)

      cookies[:token] = JsonWebToken.encode(user_id: client[:id])
      
      put "update", params: {
        author_id: author[:id],
        author: {
          full_name: "Anthony Frederic",
          biography: author[:biography],
          birth_date: author[:birth_date],
        }
      }

      expect(response).to have_http_status(401)
      expect(JSON.parse(response.body)).to eq({"error" => "Access to this resource is restricted to administrators only."})
    end

    it "User with type as a admin can update a author and status code is 200" do
      author = create(:author)
      
      cookies[:token] = JsonWebToken.encode(user_id: admin[:id])

      put "update", params: {
        author_id: author[:id],
        author: {
          full_name: "Anthony Frederic",
          biography: author[:biography],
          birth_date: author[:birth_date],
        }
      }

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq({"message" => "Author updated successfully"})
      expect(Author.where(full_name: "Anthony Frederic").count).to eq(1)
      expect(Author.where(full_name: author[:full_name]).count).to eq(0)
    end
    
    it "User with type as a admin cannot update a author that not exist and status code is 422" do
      attributes_author = attributes_for(:author)
      
      cookies[:token] = JsonWebToken.encode(user_id: admin[:id])

      put "update", params: {
        author_id: 1,
        author: {
          full_name: "Anthony Frederic",
          biography: attributes_author[:biography],
          birth_date: attributes_author[:birth_date],
        }
      }

      expect(response).to have_http_status(422)
      expect(JSON.parse(response.body)).to eq({"error" => "Author not found"})
    end
  end

  describe "DELETE /admin/author/:author_id" do
    it "User with type as a client cannot delete a author and status code is 401" do
      author = create(:author)

      cookies[:token] = JsonWebToken.encode(user_id: client[:id])
      
      delete "delete", params: {
        author_id: author[:id]
      }

      expect(response).to have_http_status(401)
      expect(JSON.parse(response.body)).to eq({"error" => "Access to this resource is restricted to administrators only."})
    end
    
    it "User with type as a admin can delete a author and status code is 200" do
      author = create(:author)

      cookies[:token] = JsonWebToken.encode(user_id: admin[:id])
      
      delete "delete", params: {
        author_id: author[:id]
      }

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq({"message" => "Author deleted successfully"})
      expect(Author.count).to eq(0)
    end

    it "User with type as a admin cannot delete a author that not exist and status code is 422" do

      cookies[:token] = JsonWebToken.encode(user_id: admin[:id])
      
      delete "delete", params: {
        author_id: 1
      }

      expect(response).to have_http_status(422)
      expect(JSON.parse(response.body)).to eq({"error" => "Author not found"})
    end
  end
end