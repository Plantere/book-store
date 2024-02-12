require 'rails_helper'

RSpec.describe Api::V1::BooksController, type: :controller do
  let!(:admin) { create(:user, user_type: 2) } 
  let!(:client) { create(:user, username: "sam_example", email: "sam@example.com") } 

  let!(:genre) { create(:genre) }
  let!(:publisher) { create(:publisher) }
  let!(:author) { create(:author) }

  describe "GET /book/search" do
    let!(:book) { create(:book, genre: genre, publisher: publisher, author: author) }\

    it "Can anonymous user search a book by name book and status code 200" do 
      get "search", params: {
        search: "1984"
      }

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to have_key("pagination")
      expect(JSON.parse(response.body)["data"].count).to eq(1)  
    end

    it "Can anonymous user search a book by name genre and status code 200" do 
      get "search", params: {
        genre: "Romance"
      }

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to have_key("pagination")
      expect(JSON.parse(response.body)["data"].count).to eq(1)  
    end

    it "Can anonymous user search a book without stock and status code 200" do 
      get "search", params: {
        has_stock: false
      }

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to have_key("pagination")
      expect(JSON.parse(response.body)["data"].count).to eq(0)  
    end

    it "Can anonymous user search a book with stock and status code 200" do 
      get "search", params: {
        has_stock: 1
      }

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to have_key("pagination")
      expect(JSON.parse(response.body)["data"].count).to eq(1)  
    end
  end

  describe "POST /book/cart" do
    let!(:book) { create(:book, genre: genre, publisher: publisher, author: author) }

    it "Can anonymous user get all items of carts and status code 200" do
      post "get_cart_items", params: {
        cart: [
          {
            book_id: book[:id],
            quantity: 5
          }
        ]
      }

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["data"].count).to eq(1)  
    end
  end
  
  describe "GET /book/:book_id" do
    let!(:book) { create(:book, genre: genre, publisher: publisher, author: author) }

    it "Can get a specific book based of bookId, and status code is 200" do
      get "index", params: {
        book_id: book[:id]
      }

      expect(response).to have_http_status(200)
    end

    it "Cannot get a specific book based of bookId that not exist, and status code is 422" do
      get "index", params: {
        book_id: 10
      }

      expect(response).to have_http_status(422)
      expect(JSON.parse(response.body)).to eq({"error" => "Book not found"})
    end
    
  end

  describe "GET admin/book/" do
    let!(:book) { create(:book, genre: genre, publisher: publisher, author: author) }

    it "User with a type as a client cannot get all books with informations more complete, status code is 401" do
      cookies[:token] = JsonWebToken.encode(user_id: client[:id])

      get "get_books"

      expect(response).to have_http_status(401)
      expect(JSON.parse(response.body)).to eq({"error" => "Access to this resource is restricted to administrators only."})
    end

    it "User with a type as a admin can get all books with informations more complete and status code 200" do
      cookies[:token] = JsonWebToken.encode(user_id: admin[:id])

      get "get_books"

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to have_key("pagination")
      expect(JSON.parse(response.body)["data"].count).to eq(1)
    end
    
    
  end

  describe "PUT admin/book/:book_id" do
    let!(:book) { create(:book, genre: genre, publisher: publisher, author: author) }

    it "User with a type as a client cannot update a book, status code is 401" do
      cookies[:token] = JsonWebToken.encode(user_id: client[:id])
      
      put "update", params: {
        book_id: book[:id],
        book: {
          name: book[:name],
          description: book[:description],
          price: 51.99 ,
          stock_quantity: book[:stock_quantity],
          publisher_id: book[:publisher_id],
          author_id: book[:author_id],
          genre_id: book[:genre_id],
        }
      } 

      expect(response).to have_http_status(401)
      expect(JSON.parse(response.body)).to eq({"error" => "Access to this resource is restricted to administrators only."})
    end
    
    it "User with a type as a admin can update a book price, status code is 200" do
      cookies[:token] = JsonWebToken.encode(user_id: admin[:id])
      
      put "update", params: {
        book_id: book[:id],
        book: {
          name: book[:name],
          description: book[:description],
          price: 51.99,
          stock_quantity: book[:stock_quantity],
          publisher_id: book[:publisher_id],
          author_id: book[:author_id],
          genre_id: book[:genre_id],
        }
      }

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq({"message" => "Book updated successfully"})
      expect(Book.exists?(price: 51.99)).to be_truthy
    end

    it "User with a type as a admin cannot update a book that not exist, status code is 422" do
      cookies[:token] = JsonWebToken.encode(user_id: admin[:id])
      
      put "update", params: {
        book_id: 10,
        book: {
          name: book[:name],
          description: book[:description],
          price: 51.99,
          stock_quantity: book[:stock_quantity],
          publisher_id: book[:publisher_id],
          author_id: book[:author_id],
          genre_id: book[:genre_id],
        }
      }

      expect(response).to have_http_status(422)
      expect(JSON.parse(response.body)).to eq({"error" => "Book not found"})
    end
  end

  describe "POST admin/book/" do
    let(:attributes_book) { attributes_for(:book, genre: genre, publisher: publisher, author: author) }

    it "User with a type as a client cannot create a book, status code is 401" do
      cookies[:token] = JsonWebToken.encode(user_id: client[:id])
      put "create", params: {
        book: {
          name: attributes_book[:name],
          description: attributes_book[:description],
          price: attributes_book[:price],
          stock_quantity: attributes_book[:stock_quantity],
          publisher_id: publisher[:id],
          author_id: author[:id],
          genre_id: genre[:id],
          images: []
        }
      }

      expect(response).to have_http_status(401)
      expect(JSON.parse(response.body)).to eq({"error" => "Access to this resource is restricted to administrators only."})
    end

    it "User with a type as a admin can create a book, status code is 200" do
      cookies[:token] = JsonWebToken.encode(user_id: admin[:id])
      put "create", params: {
        book: {
          name: attributes_book[:name],
          description: attributes_book[:description],
          price: attributes_book[:price],
          stock_quantity: attributes_book[:stock_quantity],
          publisher_id: publisher[:id],
          author_id: author[:id],
          genre_id: genre[:id],
          images: []
        }
      }

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq({"message" => "Book created successfully"})
      expect(Book.where(name: attributes_book[:name]).count).to eq(1)
    end
  end
  
end