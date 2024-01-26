class Api::V1::BooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authorize_request, only: [ :create, :update ]
  before_action :is_admin, only: [ :create, :update ]
  
  def index
    render json: Book.all
  end

  def create
    if Book.exists?(name: params_book[:name], publisher_id: params_book[:publisher_id], author_id: params_book[:author_id])
      render json: { error: "Book already exists" }, status: :unprocessable_entity
      return
    end

    book = Book.new(params_book)
    if book.save
      render json: { message: "Book created successfully" }, status: :ok
      return
    end

    render json: { error: "Failed to create book. Please check the provided data." }, status: :unprocessable_entity
  end


  def update 
    if !Book.exists(id: params[:book_id])
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
    books = Book.joins(:publisher, :author, :genre).where("LOWER(books.name) LIKE :search_term OR LOWER(publishers.name) LIKE :search_term OR LOWER(authors.full_name) LIKE :search_term OR LOWER(genres.name) LIKE :search_term", {search_term: "%" + Book.sanitize_sql_like(params[:search].downcase) + "%"}).all

    page, data = pagy(books, page: params[:page])
    pagination = pagy_metadata(page)

    render json: PaginationHelper.humanize_pagination(data, pagination, [:author, :publisher, :genre]), status: :ok
  end

  private
  def params_book
    params.require(:book).permit(:name, :description, :price, :stock_quantity, :publisher_id, :author_id, :genre_id)
  end
end
