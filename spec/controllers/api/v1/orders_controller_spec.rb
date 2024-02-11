require 'rails_helper'

RSpec.describe Api::V1::OrdersController, type: :controller do
  describe "POST /order/" do
    let(:client) { create(:user, username: "sam_example", email: "sam@example.com") } 
    let!(:client_profile) { create(:profile, user_id: client[:id]) } 
    let(:address) { create(:address, user_id: client[:id]) } 
    let(:book) { create(:book) } 

    it "User not authenticated cannot create a order, and status code is 401" do
      post "create", params: {
        cart: [
          book_id: book[:id],
          quantity: 2,
        ],
        address: address[:id],
        carrier: 1
      }

      expect(response).to have_http_status(401)
      expect(JSON.parse(response.body)).to eq({"error" => "You are not logged in. Please sign in to access the features"})
      expect(Order.count).to eq(0)
      expect(OrderDetail.count).to eq(0)
    end
    
    it "User authenticate can create a order, and status code is 200" do
      cookies[:token] = JsonWebToken.encode(user_id: client[:id])
      
      post "create", params: {
        cart: [
          book_id: book[:id],
          quantity: 2,
        ],
        address: address[:id],
        carrier: 1
      }

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["message"]).to eq("Order created successfully")
      expect(JSON.parse(response.body)).to have_key("client_secret")
      expect(Order.count).to eq(1)
      expect(OrderDetail.count).to eq(1)
    end
    
    it "User authenticate cannot create a order with book that not have stock, and status code 422" do
      cookies[:token] = JsonWebToken.encode(user_id: client[:id])
      post "create", params: {
        cart: [
          book_id: book[:id],
          quantity: 21,
        ],
        address: address[:id],
        carrier: 1
      }

      expect(response).to have_http_status(422)
      expect(JSON.parse(response.body)["error"]).to eq("Invalid book quantities in the order")
      expect(JSON.parse(response.body)["data"]).to eq([
        {
          "id" => book[:id],
          "stock_quantity" => book[:stock_quantity]
        }
      ])
    end

    it "User authenticate cannot create a order with book that not exist, and status code 422" do
      cookies[:token] = JsonWebToken.encode(user_id: client[:id])

      post "create", params: {
        cart: [
          book_id: 1,
          quantity: 1,
        ],
        address: address[:id],
        carrier: 1
      }
      
      expect(response).to have_http_status(422)
      expect(JSON.parse(response.body)).to eq("error" => "No books in your cart")
      expect(Order.count).to eq(0)
      expect(OrderDetail.count).to eq(0)
    end
    

    it "User authenticate cannot create a order with address that not exist, and status code 422" do
      cookies[:token] = JsonWebToken.encode(user_id: client[:id])

      post "create", params: {
        cart: [
          book_id: book[:id],
          quantity: 1,
        ],
        address: 1,
        carrier: 1
      }
      
      expect(response).to have_http_status(422)
      expect(JSON.parse(response.body)).to eq("error" => "Address provided is invalid to process transaction")
      expect(Order.count).to eq(0)
      expect(OrderDetail.count).to eq(0)
    end
  end
  
  describe "GET /order/" do
    let!(:client) { create(:user, username: "sam_example", email: "sam@example.com") } 
    let!(:client_profile) { create(:profile, user_id: client[:id]) } 
    let!(:address) { create(:address, user_id: client[:id]) } 
    let!(:book) { create(:book) } 
    let!(:order) { create(:order, user_id: client[:id], address_id: address[:id]) } 
    let!(:order_detail) { create(:order_detail, order_id: order[:id], book_id: book[:id]) } 

    it "User not authenticated cannot get order, and status code 401" do
      get "get"

      expect(response).to have_http_status(401)
      expect(JSON.parse(response.body)).to eq({"error" => "You are not logged in. Please sign in to access the features"})
    end
    
    
    it "User authenticated can get order, and status 200" do
      order.update!(status: 1)
      cookies[:token] = JsonWebToken.encode(user_id: client[:id])

      get "get"

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to have_key("pagination")
      expect(JSON.parse(response.body)["data"].count).to eq(1) 
    end
  end

  describe "GET /admin/order/" do
    let!(:client) { create(:user, username: "sam_example", email: "sam@example.com") } 
    let!(:admin) { create(:user, user_type: 2) } 
    let!(:client_profile) { create(:profile, user_id: client[:id]) } 
    let!(:address) { create(:address, user_id: client[:id]) } 
    let!(:book) { create(:book) } 
    let!(:order) { create(:order, user_id: client[:id], address_id: address[:id]) } 
    let!(:order_detail) { create(:order_detail, order_id: order[:id], book_id: book[:id]) } 

    it "User with type as a client cannot get all orders and status code 401" do
      cookies[:token] = JsonWebToken.encode(user_id: client[:id])

      get "get_all"

      expect(response).to have_http_status(401)
      expect(JSON.parse(response.body)).to eq({"error" => "Access to this resource is restricted to administrators only."})
    end

    it "User with type as a admin can get all orders and status code 200" do
      cookies[:token] = JsonWebToken.encode(user_id: admin[:id])

      get "get_all"

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to have_key("pagination")
      expect(JSON.parse(response.body)["data"].count).to eq(1) 
    end
  end
end