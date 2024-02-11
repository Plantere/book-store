require 'rails_helper'

RSpec.describe Api::V1::AddressesController, type: :controller do
  let!(:client) { create(:user, username: "sam_example", email: "sam@example.com") }
  let!(:other_client) { create(:user) }
  let(:other_address) { create(:address, user_id: other_client[:id], is_default: true) }  
  let!(:address) { create(:address, user_id: client[:id], is_default: true) }  
  let!(:second_address) { create(:address, name: "Address 2", postal_code: "55555", is_default: false, user_id: client[:id]) }  

  describe "GET /address" do
    it "User need to be authenticated to get addresses, status code 401" do
      get "get"

      expect(response).to have_http_status(401)
      expect(JSON.parse(response.body)).to eq({"error" => "You are not logged in. Please sign in to access the features"})
    end
    
    it "User authenticated can get addresses, status code 200" do
      cookies[:token] = JsonWebToken.encode(user_id: client[:id])

      get "get"

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to have_key("pagination") 
      expect(JSON.parse(response.body)).to have_key("data") 
      expect(JSON.parse(response.body)["data"].count).to eq(2) 
    end
    
  end
  
  describe "POST /address" do
    it "User need to be authenticated to create address, status code 401" do
      post "create"

      expect(response).to have_http_status(401)
      expect(JSON.parse(response.body)).to eq({"error" => "You are not logged in. Please sign in to access the features"})
    end
    
    it "User authenticated can create a address, status code 200" do
      cookies[:token] = JsonWebToken.encode(user_id: client[:id])

      post "create", params: {
        address: {
          name: "Address Ohio", 
          is_default: false,
          country: "United State", 
          state: "Ohio", 
          district: "Upland Avenue", 
          postal_code: "43537", 
          number: "1855", 
          complement: "-", 
          phone_number: "419-897-1460", 
          street: "Chesham", 
          city: "Maumee"
        }
      }

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq({"message" => "Address created successfully"})
    end
  end

  describe "DELETE /address/:address_id" do
    it "User need to be authenticated to destroy address, status code 401" do
      delete "delete", params: {
        address_id: address[:id]
      }

      expect(response).to have_http_status(401)
      expect(JSON.parse(response.body)).to eq({"error" => "You are not logged in. Please sign in to access the features"})
    end

    it "User authenticated can destory address, status code 200" do
      cookies[:token] = JsonWebToken.encode(user_id: client[:id])

      delete "delete", params: {
        address_id: address[:id]
      }

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq({"message" => "Address deleted successfully" })
    end

    it "User authenticated cannot destory address that not exist, status code 422" do
      cookies[:token] = JsonWebToken.encode(user_id: client[:id])

      delete "delete", params: {
        address_id: 10
      }

      expect(response).to have_http_status(422)
      expect(JSON.parse(response.body)).to eq({"error" => "Address not found" })
    end

    it "User authenticated cannot destory address that is not of user, status code 422" do
      cookies[:token] = JsonWebToken.encode(user_id: client[:id])

      delete "delete", params: {
        address_id: other_address[:id]
      }

      expect(response).to have_http_status(422)
      expect(JSON.parse(response.body)).to eq({"error" => "Address not found" })
    end
  end

  describe "PUT /address/:address_id" do
    it "User need to be authenticated to update address, status code 401" do
      put "update", params: {
        address_id: address[:id]
      }

      expect(response).to have_http_status(401)
      expect(JSON.parse(response.body)).to eq({"error" => "You are not logged in. Please sign in to access the features"})
    end


    it "User authenticated can update address, status code 200" do
      cookies[:token] = JsonWebToken.encode(user_id: client[:id])
      
      put "update", params: {
        address_id: address[:id],
        address: {
          name: "My Address", 
          country: address[:country], 
          state: address[:state], 
          district: address[:district], 
          postal_code: address[:postal_code], 
          number: address[:number], 
          complement: address[:complement], 
          phone_number: address[:phone_number], 
          street: address[:street], 
          city: address[:city]
        }
      }

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq({"message" => "Address updated successfully"})
      expect(Address.where(name: "Address 1").count).to eq(0)
      expect(Address.where(name: "My Address").count).to eq(1)
    end

    it "User authenticated cannot update address that not exist, status code 200" do
      cookies[:token] = JsonWebToken.encode(user_id: client[:id])
      
      put "update", params: {
        address_id: 10,
        address: {
          name: "My Address", 
          country: address[:country], 
          state: address[:state], 
          district: address[:district], 
          postal_code: address[:postal_code], 
          number: address[:number], 
          complement: address[:complement], 
          phone_number: address[:phone_number], 
          street: address[:street], 
          city: address[:city]
        }
      }

      expect(response).to have_http_status(422)
      expect(JSON.parse(response.body)).to eq({"error" => "Address not found"})
    end
  end

  describe "PUT /default/:address_id" do
    it "User need to be authenticated to update default address, status code 401" do
      put "update_default", params: {
        address_id: second_address[:id]
      }

      expect(response).to have_http_status(401)
      expect(JSON.parse(response.body)).to eq({"error" => "You are not logged in. Please sign in to access the features"})
    end

    it "User authenticated to update default address, status code 200" do
      cookies[:token] = JsonWebToken.encode(user_id: client[:id])
      
      put "update_default", params: {
        address_id: second_address[:id]
      }

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq({"message" => "Address set as default"})
      expect(Address.where(id: second_address[:id], is_default: true).count).to eq(1)
      expect(Address.where(id: address[:id], is_default: false).count).to eq(1)
    end
    
    it "User authenticated cannot update default address of not exist address, status code 422" do
      cookies[:token] = JsonWebToken.encode(user_id: client[:id])

      put "update_default", params: {
        address_id: 10
      }
      expect(response).to have_http_status(422)
      expect(JSON.parse(response.body)).to eq({"error" => "Address not found"})
    end
  end
end