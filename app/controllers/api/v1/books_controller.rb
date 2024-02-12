class Api::V1::BooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authorize_request, only: [ :create, :update, :get_books ]
  before_action :is_admin, only: [ :create, :update, :get_books ]
  
  def index
    if !Book.exists?(id: params[:book_id])
      render json: { error: "Book not found" }, status: :unprocessable_entity
      return
    end

    book = Book.find(params[:book_id])

    render json: {
      id: book.id,
      name: book.name,
      stock_quantity: book.stock_quantity,
      description: book.description,
      genre: book.genre.name,
      image: book.book_image,
      author: {
        name: book.author.full_name
      },
      publisher: {
        name: book.publisher.name
      }
    }
  end

  def create
    if Book.exists?(name: params_book[:name], publisher_id: params_book[:publisher_id], author_id: params_book[:author_id])
      render json: { error: "Book already exists" }, status: :unprocessable_entity
      return
    end

    book = Book.new(params_book)
    if book.save
      BookImagesHelper.create_image(book, params[:images]) if params[:images]
      render json: { message: "Book created successfully" }, status: :ok
      return
    end

    render json: { error: "Failed to create book. Please check the provided data." }, status: :unprocessable_entity
  end


  def update 
    if !Book.exists?(id: params[:book_id])
      render json: { error: "Book not found" }, status: :unprocessable_entity
      return
    end

    book = Book.find(params[:book_id])
    if book.update(params_book)
      render json: { message: "Book updated successfully" }, status: :ok
      return
    end
    
    render json: { error: "Failed to updated book. Please check the provided data." }, status: :unprocessable_entity
  end


  def search
    page, data = pagy(BooksHelper.get_filtered_books(params_search).all, page: params[:page])
    pagination = pagy_metadata(page)

    render json: {
      pagination: pagination,
      data: data.map{ |book| {
          id: book.id, 
          title: book.name, 
          price: book.price,
          image: book.book_image.get_default_or_first(),
          stock_quantity: book.stock_quantity,
        }}
      }, status: :ok
  end

  def get_cart_items
    books = Book.where(id: params[:cart].map{|book| book[:book_id]}).all
    
    render json: {
      data: books.map{ |book| {
        id: book.id,
        name: book.name,
        image: book.book_image.get_default_or_first(),
        price: book.price,
        cart_quantity: params[:cart].find{|item| item[:book_id] == book[:id]}[:quantity],
        stock_quantity: book.stock_quantity,
      }}
    }
  end

  def get_books
    page, data = pagy(BooksHelper.get_filtered_books(params_search).all, page: params[:page])
    pagination = pagy_metadata(page)

    render json: {
      pagination: pagination,
      data: data.map{ |book| {
          id: book.id, 
          title: book.name, 
          price: book.price, 
          images: book.book_image.map{ |image| {
            path: image[:path],
            is_default: image[:is_default],
            token_image: image[:token_image]
          }},
          genre: {
            id: book.genre.id,
            name: book.genre.name
          }, 
          description: book.description, 
          author: {
            id: book.author.id,
            name: book.author.full_name
          },
          publisher: {
            id: book.publisher.id,
            name: book.publisher.name
          },
          stock_quantity: book.stock_quantity,
        }}
      }, status: :ok
  end

  private
  def params_book
    params.require(:book).permit(:name, :description, :price, :stock_quantity, :publisher_id, :author_id, :genre_id)
  end

  def params_search
    params.permit(:search, :genre, :has_stock, :status)
  end
end
